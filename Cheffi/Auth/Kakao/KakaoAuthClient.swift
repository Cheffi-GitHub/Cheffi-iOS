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
    }
    
    private let tokenVerifier = KakaoTokenVerifier()
    private let loginHandler = KakaoLoginHandler()
    
    func loginWithKakao() -> AnyPublisher<OAuthToken?, KakaoAuthError> {
        return tokenVerifier.verifyKakaoToken()
            .replaceError(with: nil)
            .flatMap { accessTokenInfo in
                if let accessTokenInfo = accessTokenInfo {
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
