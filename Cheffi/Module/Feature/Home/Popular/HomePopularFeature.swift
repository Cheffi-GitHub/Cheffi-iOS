//
//  HomePopularFeature.swift
//  Cheffi
//
//  Created by 정건호 on 6/3/24.
//

import Foundation
import ComposableArchitecture

struct HomePopularFeature: Reducer {
    
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case showToolTip
        case pushViewAll
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .showToolTip:
                print("툴팁 보여주기")
                return .none
            case .pushViewAll:
                print("전체보기 화면 이동")
                return .none
            }
        }
    }
}
