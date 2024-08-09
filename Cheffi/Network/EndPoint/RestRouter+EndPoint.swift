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
    
    var pathParameters: Parameters {
        return extractParameters { path.contains("{\($0)}") }
    }
    
    var queryParameters: Parameters {
        return extractParameters { !path.contains("{\($0)}") }
    }
    
    var options: HTTPOptions {
        switch self {
        case .oauthLoginKakao,
             .testUpload:
            return (.post, .body)
            
        case .avatarsNickname,
             .popularReviews,
             .cheffiPlace,
             .reviewDetail,
             .tags,
             .testSessionIssue,
             .testAuth:
            return (.get, .query)
            
        case .profile:
            return (.get, .path)
            
        case .profileReviews,
             .profilePurchase,
             .profileBookmarks:
            return (.get, .pathQuery)
        }
    }
}

extension RestRouter {
    private func extractParameters(_ condition: (String) -> Bool) -> Parameters {
        let mirror = Mirror(reflecting: self)
        var parameters: Parameters = [:]
        
        for case let (_, rest) in mirror.children {
            let api = Mirror(reflecting: rest)
            
            for case let (key, value) in api.children {
                guard let key = key, !key.isEmpty else { continue }
                
                if case Optional<Any>.none = value { continue }
                
                if condition(key) {
                    parameters.updateValue(value, forKey: key)
                }
            }
        }
        
        return parameters
    }
}
