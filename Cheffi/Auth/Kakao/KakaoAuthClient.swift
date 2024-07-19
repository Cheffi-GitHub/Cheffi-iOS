//
//  KakaoAuthClient.swift
//  Cheffi
//
//  Created by 이서준 on 6/20/24.
//

import Foundation
import Combine
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon
import ComposableArchitecture

struct KakaoAuthClient {
    
    enum KakaoAuthError: Error {
        case emptyToken
        case invalidToken
        case notFoundKakaotalk
        case failedOAuthLoginKakao
        case sdk(SdkError)
        case unknown(Error?)
    }
    
    @Dependency(\.networkClient) private var networkClient
    
    private let tokenVerifier = KakaoTokenVerifier()
    private let loginHandler = KakaoLoginHandler()
    
    /// 카카오톡 SNS 자동 로그인을 요청합니다.
    func requestAutoLogin() -> AnyPublisher<LoginKakaoResponse, KakaoAuthError> {
        return verifyKakaoToken()
            .flatMap { requestLoginCheffi(with: $0) }
            .eraseToAnyPublisher()
    }
    
    /// 카카오톡 SNS 로그인 버튼 탭을 통한 수동 로그인을 요청합니다.
    func requestManualLogin() -> AnyPublisher<LoginKakaoResponse, KakaoAuthError> {
        return loginWithKakao()
            .flatMap { requestLoginCheffi(with: $0) }
            .eraseToAnyPublisher()
    }
    
    /// 현재 가지고 있는 유효한 토큰을 확인하고, 반환합니다.
    func verifyKakaoToken() -> AnyPublisher<OAuthToken, KakaoAuthError> {
        return tokenVerifier.verifyKakaoToken()
            .replaceError(with: nil)
            .flatMap { accessTokenInfo in
                if let _ = accessTokenInfo,
                   let oauthToken = TokenManager.manager.getToken() {
                    // 토큰 저장소, 기기 고유값으로 암호화된 OAuth 토큰 가져옴, 로그인 다시 할 필요 없음
                    return Just(oauthToken)
                        .setFailureType(to: KakaoAuthError.self)
                        .eraseToAnyPublisher()
                }
                
                return Fail(
                    outputType: OAuthToken.self,
                    failure: KakaoAuthError.invalidToken
                )
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    /// 카카오 SDK 기반으로 토큰 유효성 검사를 진행하고, 카카오 소셜 로그인을 수행합니다.
    func loginWithKakao() -> AnyPublisher<OAuthToken, KakaoAuthError> {
        return loginHandler.handleKakaoLogin()
            .flatMap { oauthToken in
                guard let oauthToken = oauthToken else {
                    return Fail(
                        outputType: OAuthToken.self,
                        failure: KakaoAuthError.unknown(nil)
                    )
                    .eraseToAnyPublisher()
                }
                return Just(oauthToken)
                    .setFailureType(to: KakaoAuthError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    /// 카카오 소셜 로그인 결과 Token(id token)으로 Cheffi API Session Token을 발급받습니다.
    func requestLoginCheffi(
        with oauthToken: OAuthToken
    ) -> AnyPublisher<LoginKakaoResponse, KakaoAuthError> {
        guard let idToken = oauthToken.idToken else {
            return Fail(
                outputType: LoginKakaoResponse.self,
                failure: KakaoAuthError.unknown(nil)
            )
            .eraseToAnyPublisher()
        }
        
        return networkClient.request(
            .oauthLoginKakao(
                token: idToken,
                platform: "IOS"
            )
        )
        .mapError { _ in
            // TODO: Cheffi API Error 종류에 따라 다양화해야 할 가능성 있음
            return KakaoAuthError.failedOAuthLoginKakao
        }
        .eraseToAnyPublisher()
    }
    
}

extension KakaoAuthClient: DependencyKey {
    static var liveValue: KakaoAuthClient = KakaoAuthClient()
}

extension DependencyValues {
    var kakaoClient: KakaoAuthClient {
        get { self[KakaoAuthClient.self] }
        set { self[KakaoAuthClient.self] = newValue }
    }
}
