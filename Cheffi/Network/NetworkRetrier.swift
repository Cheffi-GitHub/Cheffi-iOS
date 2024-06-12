//
//  NetworkRetrier.swift
//  Cheffi
//
//  Created by 이서준 on 6/6/24.
//

import Foundation
import Combine
import Alamofire

final class NetworkRetrier: RequestRetrier {
    
    private var limit: Int
    private var delay: TimeInterval
    
    init(limit: Int, delay: TimeInterval) {
        self.limit = limit
        self.delay = delay
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
    }
    
}
