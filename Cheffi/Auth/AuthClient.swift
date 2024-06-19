//
//  AuthClient.swift
//  Cheffi
//
//  Created by 이서준 on 6/19/24.
//

import Foundation
import Combine
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon
import ComposableArchitecture

struct AuthClient {
    
    // FIXME: kakao/apple oauth handle 클라이언트 분리 후 AuthClient에서 의존성 주입/관리?
    
    private func verifyKakaoToken() -> Future<AccessTokenInfo?, AuthError> {
        return Future { promise in
            // 로그인 성공시 카카오 SDK 내부에서 UserDefaults에 token을 암호화하여 저장해놓은 상태
            guard AuthApi.hasToken() else {
                promise(.failure(.emptyToken))
                return
            }
            
            UserApi.shared.accessTokenInfo { (accessTokenInfo, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() {
                        // 새로운 로그인을 통해 정상적인 토큰 발급이 필요한 상태
                        promise(.failure(.sdk(sdkError)))
                    }
                    // 카카오 SDK 이외의 기타 에러외의 토큰이 유효하지 않은 상태
                    promise(.failure(.unknown(error)))
                }
                // 토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                promise(.success(accessTokenInfo))
            }
        }
    }
    
    private func loginWithKakao() {
        // 카카오톡 설치자
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { (token, error) in
                if let error = error {
                    // TODO: 카카오톡 간편 로그인을 실행할 수 없는 상태(= case 수집 필요)
                    // ex) 사용자에 의한 취소?
                    print(error)
                } else {
                    // TODO: OIDC ID TOKEN -> Cheffi Session
                    print("Successed. OAuth token is \(token)")
                }
            }
        }
        // TODO: 카카오톡 미설치자 대응
    }
    
    // TODO: DependencyKey
}

extension AuthClient {
    enum AuthError: Error {
        case emptyToken
        case unknown(Error)
        case sdk(SdkError)
    }
}
