//
//  LoginKakaoModel.swift
//  Cheffi
//
//  Created by 이서준 on 6/24/24.
//

import Foundation

typealias LoginKakaoResponse = RestResponse<LoginKakaoModel>

struct LoginKakaoModel: Codable {
    var email: String?
    var locked: Bool?
    var expired: Bool?
    var activated: Bool?
    var lastPwChangedDate: String?
    var name: String?
    var userType: String?
    var adAgreed: Bool?
    var analysisAgreed: Bool?
    var id: Int?
    var cheffiCoinCount: Int?
    var pointCnt: Int?
    var nickname: String?
    var photoUrl: String?
    var profileCompleted: Bool?
    var authorities: [Authority]?
    var isNewUser: Bool?
}

extension LoginKakaoModel {
    enum CodingKeys: String, CodingKey {
        case email
        case locked
        case expired
        case activated
        case lastPwChangedDate = "last_pw_changed_date"
        case name
        case userType = "user_type"
        case adAgreed = "ad_agreed"
        case analysisAgreed = "analysis_agreed"
        case id
        case cheffiCoinCount = "cheffi_coin_count"
        case pointCnt = "point_cnt"
        case nickname
        case photoUrl = "photo_url"
        case profileCompleted = "profile_completed"
        case authorities
        case isNewUser = "is_new_user"
    }
}
