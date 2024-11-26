//
//  RecommendedFollower.swift
//  Cheffi
//
//  Created by 권승용 on 11/11/24.
//

import Foundation

typealias RecommendedFollowerResponse = RestResponse<[RecommendedFollower]>

struct RecommendedFollower: Codable, Hashable, Identifiable {
    let id: Int
    let nickname: String
    let photo: PhotoInfo
    let instruction: String
    let followers: Int
    var isFollowed: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, nickname, photo, instruction, followers
        case isFollowed = "followed"
    }
}
