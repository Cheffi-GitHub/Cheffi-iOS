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
                    // FIXME: 그대로 서버에 전달/오토로그인?
                    print(accessTokenInfo)
                }
                
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
