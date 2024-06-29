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
        var parameters: Parameters = [:]
        
        for case let (_, rest) in mirror.children {
            let api = Mirror(reflecting: rest)
            
            for case let (key, value) in api.children {
                if let key = key, !key.isEmpty {
                    parameters.updateValue(value, forKey: key)
                }
            }
        }
        
        return parameters
    }
    
    var method: HTTPMethod {
        switch self {
        case .oauthLoginKakao,
             .testUpload:
            return .post
            
        case .avatarsNickname,
             .popularReviews,
             .tags,
             .testSessionIssue,
             .testAuth:
            return .get
        }
    }
}
