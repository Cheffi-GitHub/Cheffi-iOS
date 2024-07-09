//
//  DataRequest+Response.swift
//  Cheffi
//
//  Created by 이서준 on 7/9/24.
//

import Foundation
import Combine
import Alamofire

extension DataRequest {
    func cheffiResponseDecodable<T: Decodable>(
        of type: T.Type = T.self,
        queue: DispatchQueue = .main,
        decoder: DataDecoder = JSONDecoder()
    ) -> AnyPublisher<T, CheffiError> {
        return Future { promise in
            self.responseDecodable(of: type, queue: queue, decoder: decoder) { response in
                switch response.result {
                case .success(let data):
                    promise(.success(data))
                case .failure(let error):
                    guard let statusCode = response.response?.statusCode else {
                        promise(.failure(.unknown(message: error.localizedDescription)))
                        return
                    }
                    
                    if let data = response.data,
                       let errorResponse = try? JSONDecoder().decode(RestErrorResponse.self, from: data) {
                        promise(.failure(.failureResponse(statusCode: statusCode, error: errorResponse)))
                    }
                    else if error.isResponseSerializationError {
                        promise(.failure(.invaildSpec(message: error.localizedDescription)))
                    }
                    else if (500 ..< 600).contains(statusCode) {
                        promise(.failure(.internalServerError(statusCode: statusCode)))
                    }
                    else {
                        promise(.failure(.unknown(message: error.localizedDescription)))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
