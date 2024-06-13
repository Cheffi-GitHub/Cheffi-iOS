//
//  NetworkEventLogger.swift
//  Cheffi
//
//  Created by 이서준 on 6/13/24.
//

import Foundation
import Alamofire

struct NetworkEventLogger: EventMonitor {
    
    let queue = DispatchQueue(label: "network.logger.queue")
    
    func requestDidFinish(_ request: Request) {
        print("""
        \n
        -------------------------------------------------------
                        🤙 Called Request Log
        -------------------------------------------------------
        """)
        print(request.description)
        print("""
        URL: \(request.request?.url?.absoluteString ?? "")
        Method: \(request.request?.httpMethod ?? "")
        Headers: \(request.request?.allHTTPHeaderFields ?? [:])
        -------------------------------------------------------
        """)
        print("""
        Body: \(request.request?.httpBody?.toPrettyPrintedString ?? "{ \n}")
        -------------------------------------------------------
        """)
    }
    
    func request<Value>(
        _ request: DataRequest,
        didParseResponse response: DataResponse<Value, AFError>
    ) {
        print("""
        \n
        -------------------------------------------------------
                       🛰️ Received Request Log
        -------------------------------------------------------
        """)
        switch response.result {
        case .success:
            print("Result: success")
        case .failure:
            print("Result: failure")
        }
        print("""
        StatusCode: \(response.response?.statusCode ?? -1)
        -------------------------------------------------------
        """)
        print("""
        \(response.data?.toPrettyPrintedString ?? "{ \n\n}")
        -------------------------------------------------------
        """)
    }
}
