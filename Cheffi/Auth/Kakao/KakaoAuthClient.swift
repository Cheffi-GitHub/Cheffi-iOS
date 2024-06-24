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
        case unknown(Error?)
        case sdk(SdkError)
        case notFoundKakaotalk
        case failedOAuthLoginKakao
    }
    
    @Dependency(\.networkClient) var networkClient
    
    private let tokenVerifier = KakaoTokenVerifier()
    private let loginHandler = KakaoLoginHandler()
    
    /// 카카오 소셜 로그인 결과 Token(id token)으로 Cheffi API Session Token을 발급받습니다.
    func requestOAuthLoginKakao() -> AnyPublisher<LoginKakaoResponse, KakaoAuthError> {
        return loginWithKakao()
            .flatMap { oauthToken in
                return networkClient.request(
                    .oauthLoginKakao(
                        token: oauthToken?.idToken ?? "",
                        platform: "IOS"
                    )
                )
                .mapError { _ in
                    // TODO: Cheffi API Error 종류에 따라 다양화해야 할 가능성 있음
                    return KakaoAuthError.failedOAuthLoginKakao
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    /// 카카오 SDK 기반으로 토큰 유효성 검사를 진행하고, 카카오 소셜 로그인을 수행합니다.
    private func loginWithKakao() -> AnyPublisher<OAuthToken?, KakaoAuthError> {
        return tokenVerifier.verifyKakaoToken()
            .replaceError(with: nil)
            .flatMap { accessTokenInfo in
                if let _ = accessTokenInfo {
                    // 토큰 저장소, 기기 고유값으로 암호화된 OAuth 토큰 가져옴, 로그인 다시 할 필요 없음
                    return Just(TokenManager.manager.getToken())
                        .setFailureType(to: KakaoAuthError.self)
                        .eraseToAnyPublisher()
                }
                
                // 토큰이 존재하지 않거나, 유효하지 않다면 새로운 로그인을 통해 OAuthToken을 발급
                return loginHandler.handleKakaoLogin()
                    .eraseToAnyPublisher()
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
