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
    var method: HTTPMethod { get }
}

extension EndPoint {
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: baseURL.appending(path)) else {
            throw AFError.createURLRequestFailed(error: URLError(.badURL))
        }
        
        var urlRequest = try URLRequest(url: url, method: method)
        urlRequest.headers = headers

        switch method {
        case .get:
            urlRequest = try URLEncoding.queryString
                .encode(urlRequest, with: parameters)
        default:
            urlRequest = try JSONEncoding(options: .prettyPrinted)
                .encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
