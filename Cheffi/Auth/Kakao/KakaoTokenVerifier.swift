//
//  KakaoTokenVerifier.swift
//  Cheffi
//
//  Created by 이서준 on 6/20/24.
//

import Combine
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

struct KakaoTokenVerifier {
    typealias KakaoAuthError = KakaoAuthClient.KakaoAuthError
    
    func verifyKakaoToken() -> Future<AccessTokenInfo?, KakaoAuthError> {
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
}
