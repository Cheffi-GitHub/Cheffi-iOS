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
