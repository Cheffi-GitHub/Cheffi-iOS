//
//  RootFeature.swift
//  Cheffi
//
//  Created by 이서준 on 7/17/24.
//

import Combine
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
        case presentAuthentication
        case successKakaoAutoLogin(LoginKakaoResponse)
        case launchScreenAction(LaunchScreenFeature.Action)
        case loginAction(LoginFeature.Action)
        case mainTabAction(MainTabFeature.Action)
    }
    
    enum AppRootState {
        case launchScreen
        case authentication
        case main
    }
    
    @Dependency(\.kakaoClient) var kakaoClient
    
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
                    return Effect.publisher {
                        // TODO: Apple Login 구현 후 2가지 자동 로그인 시나리오 분기처리
                        return kakaoClient.requestAutoLogin()
                            .map { Action.successKakaoAutoLogin($0) }
                            .catch { _ in Just(Action.presentAuthentication) }
                    }
                    
                case .successKakaoAutoLogin:
                    state.currentRoot = .main
                    return .none
                    
                case .presentAuthentication:
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
