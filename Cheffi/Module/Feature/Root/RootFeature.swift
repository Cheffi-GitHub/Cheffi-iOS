//
//  RootFeature.swift
//  Cheffi
//
//  Created by 이서준 on 7/17/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RootFeature {
    
    @ObservableState
    struct State: Equatable {
        var currentRoot: AppRootState = .launchScreen
        var launchScreenState: LaunchScreenFeature.State = .init()
        var loginState: LoginFeature.State = .init()
        var mainTabState: MainTabFeature.State = .init()
    }
    
    enum Action {
        case launchScreenAction(LaunchScreenFeature.Action)
        case loginAction(LoginFeature.Action)
        case mainTabAction(MainTabFeature.Action)
    }
    
    enum AppRootState {
        case launchScreen
        case authentication
        case main
    }
    
    var body: some Reducer<State, Action> {
        CombineReducers {
            Scope(state: \.launchScreenState, action: \.launchScreenAction) {
                LaunchScreenFeature()
            }
            
            Scope(state: \.loginState, action: \.loginAction) {
                LoginFeature()
            }
            
            Scope(state: \.mainTabState, action: \.mainTabAction) {
                MainTabFeature()
            }
            
            Reduce { state, action in
                switch action {
                case .launchScreenAction(.presentAuthentication):
                    state.currentRoot = .authentication
                    return .none
                    
                case .loginAction(.presentMain):
                    state.currentRoot = .main
                    return .none
                    
                case .launchScreenAction:
                    return .none
                    
                case .loginAction:
                    return .none
                    
                case .mainTabAction:
                    return .none
                }
            }
        }
    }
}
