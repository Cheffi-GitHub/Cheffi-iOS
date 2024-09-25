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
    
    static let dummy: ReviewDetailModel = .init(
    id: 1,
    title: "태초동에 생긴 맛집!",
    text: "초밥 태초세트 추천해요",
    bookmarked: false,
    ratedByUser: false,
    ratingType: "GOOD",
    createdDate: "2024-09-25T18:57:17.865Z",
    timeLeftToLock: 86399751,
    matchedTagNum: 3,
    restaurant: Restaurant(
        id: 3,
        name: "을밀대",
        address: Address(
            province: "서울특별시",
            city: "양천구",
            roadName: "숭문길 24",
            fullLotNumberAddress: "서울시 마포구 염리동 111",
            fullRoadNameAddress: "서울시 마포구 숭문길 24"
        ),
        registered: true
    ),
    writer: Writer(
        id: 1,
        nickname: "닉네임1234",
        photo: PhotoInfo(
            url: "https://www~~~.com",
            width: 320,
            height: 320
        ),
        introduction: "안녕하세요, 리뷰 작성자입니다.",
        writtenByViewer: false
    ),
    ratings: Ratings(
        good: 0,
        average: 0,
        bad: 0
    ),
    photos: [
        Photo(
            id: 1,
            order: 1,
            photo: PhotoInfo(
                url: "https://www~~~.com",
                width: 320,
                height: 320
            )
            )
    ],
    menus: [
        Menu(
            name: "곱창 전골",
            price: 80000,
            description: "string"
        )
    ]
    )
}








