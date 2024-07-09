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
                    
                    if let data = response.data {
                        promise(.failure(.failureWithErrorData(statusCode: statusCode, error: data)))
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

extension Publisher where Failure == CheffiError {
    func mapErrorResponse() -> Publishers.MapError<Self, CheffiError> {
        return self.mapError { error in
            if case let .failureWithErrorData(statusCode, data) = error {
                if let errorResponse = try? JSONDecoder().decode(
                    RestErrorResponse.self,
                    from: data
                ) {
                    return CheffiError.failureWithParsedError(
                        statusCode: statusCode,
                        error: errorResponse
                    )
                } else {
                    return CheffiError.failedParsingErrorData(
                        statusCode: statusCode
                    )
                }
            }
            return error
        }
    }
}
