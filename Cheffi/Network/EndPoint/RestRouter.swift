//
//  RestRouter.swift
//  Cheffi
//
//  Created by 이서준 on 6/7/24.
//

import Foundation

enum RestRouter {
    // - MARK: OAuth
    // 소셜 로그인 API { 카카오톡 }
    case oauthLoginKakao(token: String, platform: String)
    
    // - MARK: 회원가입
    case avatarsNickname(nickName: String)
    
    // - MARK: Test
    // 이미지 업로드 테스트 API
    case testUpload
    // 테스트용 세션 발급 API
    case testSessionIssue
    // 세션 토큰 테스트 API
    case testAuth
}
