//
//  URLParameterEncoding.swift
//  Cheffi
//
//  Created by 이서준 on 8/2/24.
//

import Foundation
import Alamofire

typealias HTTPOptions = (method: HTTPMethod, encodingType: URLParameterEncoding)

enum URLParameterEncoding {
    case path
    case query
    case pathQuery
    case body
}
