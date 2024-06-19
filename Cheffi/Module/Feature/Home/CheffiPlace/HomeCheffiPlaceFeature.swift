//
//  HomeCheffiPlaceFeature.swift
//  Cheffi
//
//  Created by 정건호 on 6/10/24.
//

import Foundation
import ComposableArchitecture

struct HomeCheffiPlaceFeature: Reducer {
    
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {
        case toolTipTapped
        case tagTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .toolTipTapped:
                print("툴팁 보여주기")
                return .none
            case .tagTapped:
                print("api 호출")
                return .none
            }
        }
    }
}
