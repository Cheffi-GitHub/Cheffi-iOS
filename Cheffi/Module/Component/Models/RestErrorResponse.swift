//
//  RestErrorResponse.swift
//  Cheffi
//
//  Created by 이서준 on 7/9/24.
//

import Foundation
import AnyCodable

struct RestErrorResponse: Codable, Error {
    var errorCode: String?
    var errorMessage: String?
    var data: [String: AnyCodable]?
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case data = "data"
    }
}
