//
//  NetworkClient.swift
//  Cheffi
//
//  Created by 이서준 on 6/6/24.
//

import Foundation
import Combine
import Alamofire
import ComposableArchitecture

struct NetworkClient {
    
    let session: Session
    let queue: DispatchQueue
    
    init(
        session: Session,
        queue: DispatchQueue = DispatchQueue(
            label: "network.queue",
            qos: .userInitiated,
            attributes: .concurrent
        )
    ) {
        self.session = session
        self.queue = queue
    }
    
    func request<Value: Codable>(_ endPoint: RestRouter) -> AnyPublisher<Value, CheffiError> {
        return session.request(endPoint)
            .validate()
            .cheffiResponseDecodable(of: Value.self)
            .mapErrorResponse()
            .subscribe(on: queue)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension NetworkClient: DependencyKey {
    static var liveValue: NetworkClient {
        let configuration = URLSessionConfiguration.af.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        
        let queue: DispatchQueue = DispatchQueue(
            label: "network.queue",
            qos: .userInitiated,
            attributes: .concurrent
        )
        
        return NetworkClient(
            session: Session(
                configuration: configuration,
                interceptor: NetworkRequestInterceptor(
                    limit: 3,
                    delay: 3
                ),
                eventMonitors: [
                    NetworkEventLogger(),
                    TokenStorageEventMonitor()
                ]
            ),
            queue: queue
        )
    }
    
    // TODO: testValue(mocking)
}

extension DependencyValues {
    var networkClient: NetworkClient {
        get { self[NetworkClient.self] }
        set { self[NetworkClient.self] = newValue }
    }
}
