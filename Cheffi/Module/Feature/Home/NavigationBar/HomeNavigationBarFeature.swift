//
//  NavigationBarFeature.swift
//  Cheffi
//
//  Created by 정건호 on 6/3/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HomeNavigationBarFeature {
    
    @ObservableState
    struct State: Equatable {
    }
    
    enum Action: Equatable {
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            }
        }
    }
}
