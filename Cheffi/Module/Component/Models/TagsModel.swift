//
//  TagsModel.swift
//  Cheffi
//
//  Created by 정건호 on 6/29/24.
//

import Foundation

typealias TagsResponse = RestResponse<[TagsModel]>

struct TagsModel: Codable, Equatable {
    let id: Int
    let name: String
    let type: String
}
