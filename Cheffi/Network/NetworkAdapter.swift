//
//  NetworkAdapter.swift
//  Cheffi
//
//  Created by 이서준 on 6/12/24.
//

import Foundation
import Alamofire

struct NetworkAdapter: RequestAdapter {
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        // TODO: Request Logger
        
        // TODO: Invaild Token Handler
        completion(.success(urlRequest))
    }
}
