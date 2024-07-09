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
    case failedParsingErrorData(statusCode: Int)
    case failureWithErrorData(statusCode: Int, error: Data)
    case failureWithParsedError(statusCode: Int, error: RestErrorResponse)
}
