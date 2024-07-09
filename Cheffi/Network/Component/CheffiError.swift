//
//  CheffiError.swift
//  Cheffi
//
//  Created by 이서준 on 7/9/24.
//

import Foundation

enum CheffiError: Error {
    case unknown(message: String)
    case invaildSpec(message: String)
    case internalServerError(statusCode: Int)
    case failureResponse(statusCode: Int, error: RestErrorResponse)
}
