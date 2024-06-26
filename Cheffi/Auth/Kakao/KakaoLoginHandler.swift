//
//  KakaoLoginHandler.swift
//  Cheffi
//
//  Created by 이서준 on 6/20/24.
//

import Combine
import KakaoSDKUser
import KakaoSDKAuth

struct KakaoLoginHandler {
    typealias KakaoAuthError = KakaoAuthClient.KakaoAuthError
    
    func handleKakaoLogin() -> Future<OAuthToken?, KakaoAuthError> {
        return Future { promise in
            // 카카오톡 설치자
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk { (token, error) in
                    if let error = error {
                        // TODO: 카카오톡 간편 로그인을 실행할 수 없는 상태(= case 수집 필요)
                        // ex) 권한 요청 취소, 혹은 로그인 취소(사용자에 의한 의도적 취소)
                        promise(.failure(.unknown(error)))
                    } else {
                        // TODO: print -> Common Logger
                        //print("Successed. OAuth token is \(token)")
                        promise(.success(token))
                    }
                }
            }
            
            // TODO: Open Kakao LoginWeb?
            promise(.failure(.notFoundKakaotalk))
        }
    }
}
