//
//  ReviewDetailModel.swift
//  Cheffi
//
//  Created by 정건호 on 7/9/24.
//

import Foundation

typealias ReviewDetailResponse = RestResponse<ReviewDetailModel>

struct ReviewDetailModel: Codable, Equatable {
    let id: Int
    let title: String
    let text: String
    let bookmarked: Bool
    let ratedByUser: Bool
    let ratingType: String?
    let createdDate: String
    let timeLeftToLock: Int64
    let matchedTagNum: Int?
    let restaurant: Restaurant
    let writer: Writer
    let ratings: Ratings
    let photos: [Photo]
    let menus: [Menu]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case text
        case bookmarked
        case ratedByUser = "rated_by_user"
        case ratingType = "rating_type"
        case createdDate = "created_date"
        case timeLeftToLock = "time_left_to_lock"
        case matchedTagNum = "matched_tag_num"
        case restaurant
        case writer
        case ratings
        case photos
        case menus
    }
}








