//
//  RestResponse.swift
//  Cheffi
//
//  Created by 이서준 on 6/24/24.
//

import Foundation

struct RestResponse<T: Codable>: Codable {
    var data: T?
    var code: Int?
    var message: String?
}

struct RestPagingResponse<T: Codable>: Codable {
    var data: T?
    var code: Int?
    var message: String?
    var hasNext: Bool?
    var next: Int?
    
    enum CodingKeys: String, CodingKey {
        case data
        case code
        case message
        case hasNext = "has_next"
        case next
    }
}
