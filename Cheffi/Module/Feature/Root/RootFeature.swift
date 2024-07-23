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
        case launchScreenAction(LaunchScreenFeature.Action)
        case loginAction(LoginFeature.Action)
        case mainTabAction(MainTabFeature.Action)
        case tryKakaoAuthLogin(Result<LoginKakaoResponse, Error>)
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
                            .map { Action.tryKakaoAuthLogin(.success($0)) }
                            .catch { Just(Action.tryKakaoAuthLogin(.failure($0))) }
                    }
                    
                case .tryKakaoAuthLogin(let result):
                    // TODO: 화면 전환 시 LoginKakaoResponse 또는 KakaoAuthError 데이터가 필요한지 확인
                    switch result {
                    case .success:
                        // FIXME: 약관 화면 개발을 위한 자동로그인 비활성화
                        //state.currentRoot = .main
                        state.currentRoot = .authentication
                    case .failure:
                        state.currentRoot = .authentication
                    }
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
