//
//  RestErrorResponse.swift
//  Cheffi
//
//  Created by 이서준 on 7/9/24.
//

import Foundation

struct RestErrorResponse: Codable, Error {
    var errorCode: String?
    var errorMessage: String?
    // TODO: Cheffi Server Error Response 규격에 맞추어 data 타입 고정
    //var data: T?
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case errorMessage = "error_message"
    }
}
