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
    
    func request<Value: Codable>(_ endPoint: RestRouter) -> AnyPublisher<Value, AFError>
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
    
    func request<Value: Codable>(_ endPoint: RestRouter) -> AnyPublisher<Value, AFError> {
        return session.request(endPoint)
            .validate()
            // TODO: Progress 핸들링 -> Loading indicator 표시
            .publishDecodable(type: Value.self)
            .value()
            .subscribe(on: queue)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
