//
//  NetworkRequestInterceptor.swift
//  Cheffi
//
//  Created by 이서준 on 6/13/24.
//

import Foundation
import Alamofire

struct NetworkRequestInterceptor: RequestInterceptor {
    
    private var limit: Int
    private var delay: TimeInterval
    
    init(limit: Int, delay: TimeInterval) {
        self.limit = limit
        self.delay = delay
    }
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        var urlRequest = urlRequest
        
        if let token: String = KeychainManager.shared.load(for: "cheffi.authorization") {
            urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        // TODO: Keychain에 저장된 OAuthToken은 만료되지 않았지만, Cheffi Session에서 만료된 경우
        completion(.success(urlRequest))
    }
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: any Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard request.retryCount < limit else {
            completion(.doNotRetry)
            return
        }
        
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        
        // TODO: 재시도 불가능 케이스 수집
        // ex) 접근 권한 없음, 토큰 만료 등
        
        // TODO: retry(_: ) 메서드 제거, Custom Alert/UserAction을 통한 retry flow 구현
        
        completion(.retry)
    }
}
