//
//  RestRouter+Path.swift
//  Cheffi
//
//  Created by 이서준 on 6/23/24.
//

import Foundation

extension RestRouter {
    var path: String {
        switch self {
        case .oauthLoginKakao:
            return "/api/v1/oauth/login/kakao"
        case .avatarsNickname:
            return "/api/v1/avatars/nickname/inuse"
        case .popularReviews:
            return "/api/v1/reviews/areas"
        case .cheffiPlace:
            return "/api/v1/reviews/areas/tags"
        case .reviewDetail:
            return "/api/v1/reviews"
        case .profile:
            return "/api/v1/profile/{id}"
        case .profileReviews:
            return "/api/v1/profile/{id}/reviews"
        case .profilePurchase:
            return "/api/v1/profile/{id}/purchase"
        case .profileBookmarks:
            return "/api/v1/profile/{id}/bookmarks"
        case .tags:
            return "/api/v1/tags"
        case .testUpload:
            return "/test/upload"
        case .testSessionIssue:
            return "/test/session/issue"
        case .testAuth:
            return "/test/auth"
        }
    }
}
