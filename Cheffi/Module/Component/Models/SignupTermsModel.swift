//
//  SignupTermsModel.swift
//  Cheffi
//
//  Created by 이서준 on 7/26/24.
//

import Foundation

struct SignupTerms: Identifiable, Equatable {
    var id = UUID()
    var type: SignupTermsType
    var isSelected: Bool = false
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id && lhs.type == rhs.type && lhs.isSelected == rhs.isSelected
    }
}

enum SignupTermsType: CaseIterable {
    case ageConfirmation
    case serviceAgreement
    case personalAgreement
    case locationAgreement
    case marketingConsent
    
    var description: String {
        switch self {
        case .ageConfirmation:
            return "[필수] 만 14세 이상입니다."
        case .serviceAgreement:
            return "[필수] 서비스 이용 약관 동의"
        case .personalAgreement:
            return "[필수] 개인정보 수집 및 이용 동의"
        case .locationAgreement:
            return "[필수] 위치정보 이용동의 및 위치기반서비스 이용 동의"
        case .marketingConsent:
            return "[선택] 마케팅 정보 수신 동의"
        }
    }
    
    var isEssential: Bool {
        switch self {
        case .ageConfirmation:
            return true
        case .serviceAgreement:
            return true
        case .personalAgreement:
            return true
        case .locationAgreement:
            return true
        case .marketingConsent:
            return false
        }
    }
    
    var url: URL? {
        // TODO: Notion 약관 링크로 업데이트
        switch self {
        case .ageConfirmation:
            return nil
        case .serviceAgreement:
            return URL(string: "https://www.naver.com")!
        case .personalAgreement:
            return URL(string: "https://www.naver.com")!
        case .locationAgreement:
            return URL(string: "https://www.naver.com")!
        case .marketingConsent:
            return URL(string: "https://www.naver.com")!
        }
    }
}
