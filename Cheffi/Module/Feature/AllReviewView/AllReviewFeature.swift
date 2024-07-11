//
//  AllReviewFeature.swift
//  Cheffi
//
//  Created by 정건호 on 7/9/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AllReviewFeature {
    
    @ObservableState
    struct State: Equatable {
        var viewType: ReviewViewType = .expand
    }
    
    enum Action: Equatable {
        case changeViewType(type: ReviewViewType)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .changeViewType(let type):
                state.viewType = type
                return .none
            }
        }
    }
}
