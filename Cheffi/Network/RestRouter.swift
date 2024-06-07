//
//  RestRouter.swift
//  Cheffi
//
//  Created by 이서준 on 6/7/24.
//

import Foundation
import Alamofire

enum RestRouter {
    case testUpload
    case testSessionIssue
    case testAuth
}

extension RestRouter: EndPoint {
    var baseURL: String {
        return "http://13.124.36.101"
    }
    
    var path: String {
        return fetchPath()
    }
    
    var headers: HTTPHeaders {
        return [
            .contentType("application/json")
        ]
    }
    
    var parameters: Parameters {
        let mirror = Mirror(reflecting: self)
        
        guard let (_, value) = mirror.children.first else {
            return [:]
        }
        
        return value as? [String: Codable] ?? [:]
    }
    
    var method: HTTPMethod {
        switch self {
        case .testUpload:
            return .post
        case .testSessionIssue, .testAuth:
            return .get
        }
    }
}
 
extension RestRouter {
    // TODO: 코드 길이가 길어져서 가독성에 문제가 생길 경우 파일 분리하기
    func fetchPath() -> String {
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
