//
//  RestRouter.swift
//  Cheffi
//
//  Created by 이서준 on 6/7/24.
//

import Foundation

enum RestRouter {
    // - MARK: 01. 로그인
    case oauthLoginKakao(token: String, platform: String)
    
    // - MARK: 02. 회원가입
    case avatarsNickname(nickName: String)
    
    // - MARK: 03. 메인페이지
    case popularReviews(province: String, city: String, cursor: Int, size: Int)
    case cheffiPlace(province: String, city: String, cursor: Int, size: Int, tag_id: Int)
    case reviewDetail(id: Int)
    
    // - MARK: 04. 검색페이지
    
    // - MARK: 05. 프로필 조회
    case profile(id: String)
    case profileReviews(id: String, size: Int)
    
    // - MARK: 06. 리뷰 상세 페이지
    
    // - MARK: 07. 리뷰 등록, 수정, 삭제
    
    // - MARK: 08. 프로필 수정
    
    // - MARK: 09. 팔로우
    
    // - MARK: 10. 태그
    case tags(type: String)
    
    // - MARK: 11. 알림
    
    // - MARK: 12. 쉐피코인 및 포인트
    
    // - MARK: 13. 찜(북마크)
    
    // - MARK: 14. 지역구 조회
    
    // - MARK: 15. 신고
    
    // - MARK: 16. 차단
    
    // - MARK: 17. 자주 묻는 질문
    
    // - MARK: 18. 공지사항
    
    // - MARK: 19. 아바타
    
    // - MARK: 20. 리뷰
    
    // - MARK: ETC. 테스트
    case testUpload
    case testSessionIssue
    case testAuth
}
