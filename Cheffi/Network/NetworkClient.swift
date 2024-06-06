//
//  NetworkClient.swift
//  Cheffi
//
//  Created by 이서준 on 6/6/24.
//

import Foundation
import Combine
import Alamofire

protocol NetworkClientable {
    var session: Session { get }
    var queue: DispatchQueue { get }
    
    func request<T: Codable>(
        _ endPoint: URLRequestConvertible,
        type: T.Type
    ) -> AnyPublisher<T, AFError>
}

final class NetworkClient: NetworkClientable {
    
    let session: Session
    let queue: DispatchQueue
    
    init(
        session: Session = Session.default,
        queue: DispatchQueue = DispatchQueue(
            label: "network.queue",
            qos: .userInitiated,
            attributes: .concurrent
        )
    ) {
        self.session = session
        self.queue = queue
    }
    
    // TODO: request method 랩핑하여 타입추론 개선하기
    func request<T: Codable>(
        _ endPoint: URLRequestConvertible,
        type: T.Type
    ) -> AnyPublisher<T, AFError> {
        do {
            let urlRequest = try endPoint.asURLRequest()
            
            return session.request(urlRequest)
                .validate()
                // TODO: Progress 핸들링 -> Loading indicator 표시
                .publishDecodable(type: T.self)
                .value()
                .subscribe(on: queue)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
            
        } catch {
            return Fail(error: AFError.createURLRequestFailed(error: error))
                .eraseToAnyPublisher()
        }
    }
}
