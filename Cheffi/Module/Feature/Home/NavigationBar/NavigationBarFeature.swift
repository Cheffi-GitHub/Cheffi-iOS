//
//  NavigationBarFeature.swift
//  Cheffi
//
//  Created by 정건호 on 6/3/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct NavigationBarFeature {
    
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case regionTapped
        case searchTapped
        case alarmTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .regionTapped:
                print("지역 선택 화면 이동")
                return .none
            case .searchTapped:
                print("검색 화면 이동")
                return .none
            case .alarmTapped:
                print("알림 화면 이동")
                return .none
            }
        }
    }
}
