//
//  RestRouter+EndPoint.swift
//  Cheffi
//
//  Created by 이서준 on 6/23/24.
//

import Foundation
import Alamofire

extension RestRouter: EndPoint {
    var baseURL: String {
        do {
            return try AppEnvironment.baseURL.getValue()
        } catch {
            return ""
        }
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
