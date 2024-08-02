//
//  EndPoint.swift
//  Cheffi
//
//  Created by 이서준 on 6/6/24.
//

import Foundation
import Alamofire

protocol EndPoint: URLRequestConvertible {
    var baseURL: String { get }
    var path: String { get }
    var headers: HTTPHeaders { get }
    var parameters: Parameters { get }
    var options: HTTPOptions { get }
}

extension EndPoint {
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: baseURL.appending(path)) else {
            throw AFError.createURLRequestFailed(error: URLError(.badURL))
        }

        var urlRequest = try URLRequest(url: url, method: options.method)
        urlRequest.headers = headers
        
        return try encodeParameters(urlRequest)
    }
    
    private func encodeParameters(_ request: URLRequest) throws -> URLRequest {
        switch options.encodingType {
        case .path:
            return request
            
        case .query, .pathQuery:
            return try URLEncoding.queryString.encode(request, with: parameters)
            
        case .body:
            return try JSONEncoding.prettyPrinted.encode(request, with: parameters)
        }
    }
}
