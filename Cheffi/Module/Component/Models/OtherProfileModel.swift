//
//  OtherProfileModel.swift
//  Cheffi
//
//  Created by 이서준 on 8/2/24.
//

import Foundation

typealias OtherProfileResponse = RestResponse<OtherProfileModel>

struct OtherProfileModel: Codable {
    let id: Int
    let nickname: String
    let introduction: String?
    let followerCount: Int
    let followingCount: Int
    let post: Int
    let cheffiCoin: Int
    let point: Int
    let photo: PhotoInfo
    let following: Bool?
    let blocking: Bool?
    let tags: [TagsModel]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case nickname
        case introduction
        case followerCount = "follower_count"
        case followingCount = "following_count"
        case post
        case cheffiCoin = "cheffi_coin"
        case point
        case photo
        case following
        case blocking
        case tags
    }
}
