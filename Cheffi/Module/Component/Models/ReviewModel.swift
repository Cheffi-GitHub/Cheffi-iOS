//
//  ReviewModel.swift
//  Cheffi
//
//  Created by 정건호 on 6/27/24.
//

import Foundation

typealias ReviewResponse = RestResponse<[ReviewModel]>

struct ReviewModel: Codable, Equatable {
    let id: Int
    let title: String
    let text: String
    let photo: Photo
    let timeLeftToLock: Int
    let locked: Bool
    let viewCount: Int
    let number: Int
    let reviewStatus: String
    let writtenByUser: Bool
    let bookmarked: Bool
    let purchased: Bool
    let active: Bool
}

extension ReviewModel {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case text
        case photo
        case timeLeftToLock = "time_left_to_lock"
        case locked
        case viewCount = "view_count"
        case number
        case reviewStatus = "review_status"
        case writtenByUser = "written_by_user"
        case bookmarked
        case purchased
        case active
    }
}

extension ReviewModel {
    static var dummyData: ReviewModel {
        return ReviewModel(
            id: 1,
            title: "Amazing Restaurant",
            text: "The food was absolutely amazing and the service was excellent.",
            photo: Photo(id: 1, order: 3, photoUrl: ""),
            timeLeftToLock: 3600,
            locked: false,
            viewCount: 1234,
            number: 1,
            reviewStatus: "active",
            writtenByUser: true,
            bookmarked: false,
            purchased: true,
            active: true
        )
    }
}
