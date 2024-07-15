//
//  MainTabFeature.swift
//  Cheffi
//
//  Created by 정건호 on 7/15/24.
//

import ComposableArchitecture

@Reducer
struct MainTabFeature {
    
    @ObservableState
    struct State: Equatable {
        var presentRegisterView: Bool = false
    }
    
    enum Action {
        case toggleRegisterView(Bool)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .toggleRegisterView(let value):
                state.presentRegisterView = value
                return .none
            }
        }
    }
}
