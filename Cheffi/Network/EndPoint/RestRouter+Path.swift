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
        case .testUpload:
            return "/test/upload"
        case .testSessionIssue:
            return "/test/session/issue"
        case .testAuth:
            return "/test/auth"
        }
    }
}
