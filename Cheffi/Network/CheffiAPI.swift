//
//  CheffiAPI.swift
//  Cheffi
//
//  Created by 이서준 on 6/6/24.
//

import Foundation
import Alamofire

enum CheffiAPI { 
    case testUpload
    case testSessionIssue
    case testAuth
}

extension CheffiAPI: EndPoint {
    var baseURL: String {
        return "http://13.124.36.101"
    }
    
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
    
    var headers: HTTPHeaders {
        return [
            .contentType("application/json")
        ]
    }
    
    var parameters: Parameters {
        // TODO: 효율적인 parameter를 만드는 방법
        // 1. Codable -> Dictionary
        // 2. Enum -> Dictionary
        // 3. Protocol -> Enum(element) -> Dictionary
        return [:]
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .testUpload:
            return .post
        case .testSessionIssue, .testAuth:
            return .get
        }
    }
}
