//
//  WelcomeFeature.swift
//  Cheffi
//
//  Created by 이서준 on 10/2/24.
//

import ComposableArchitecture

@Reducer
class WelcomeFeature {
    
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action {
        case navigateToHome
    }
    
    var body: some ReducerOf<WelcomeFeature> {
        Reduce { state, action in
            return .none
        }
    }
}
