//
//  NavigationBarFeature.swift
//  Cheffi
//
//  Created by 정건호 on 6/3/24.
//

import Foundation
import ComposableArchitecture

struct NavigationBarFeature: Reducer {
    
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case pushSelectRegion
        case pushSearch
        case pushAlarm
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .pushSelectRegion:
                print("지역 선택 화면 이동")
                return .none
            case .pushSearch:
                print("검색 화면 이동")
                return .none
            case .pushAlarm:
                print("알림 화면 이동")
                return .none
            }
        }
    }
}
