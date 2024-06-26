//
//  TokenStorageEventMonitor.swift
//  Cheffi
//
//  Created by 이서준 on 6/23/24.
//

import Foundation
import Combine
import Alamofire

struct TokenStorageEventMonitor: EventMonitor {
    
    enum TokenStorageError: Error {
        case failCreate
        case parsing
        case notFound
        case unknown
    }
    
    // targtURL: "/api/v1/oauth/login/{provider}"
    // provier: kakao, apple, ...
    private let targetURL: String = "/api/v1/oauth/login"
    
    func request(
        _ request: Request,
        didCompleteTask task: URLSessionTask,
        with error: AFError?
    ) {
        guard let response = task.response as? HTTPURLResponse,
              let url = task.originalRequest?.url,
              url.absoluteString.contains(targetURL) else {
            return
        }
        
        if let token = response.allHeaderFields["Authorization"] as? String {
            // TODO: Need Common Logger case by case
            if KeychainManager.shared.save(token, for: "cheffi.authorization") {
                // Success
                print("Success")
            } else {
                // TokenStorageError.failCreate
            }
        }
    }
}
