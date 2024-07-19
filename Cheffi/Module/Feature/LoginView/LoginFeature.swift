//
//  LoginFeature.swift
//  Cheffi
//
//  Created by 이서준 on 7/13/24.
//

import Combine
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon
import ComposableArchitecture

@Reducer
struct LoginFeature {
    
    typealias KakaoAuthError = KakaoAuthClient.KakaoAuthError
    
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case alert(PresentationAction<Alert>)
        case loginWithKakao
        case successKakaoLogin(LoginKakaoResponse)
        case failureKakaoLogin(KakaoAuthError)
        case loginWithApple
        case completedLogin
        case presentMain
        
        enum Alert: Equatable {
            case notReadyAppleLogin
        }
    }
    
    @Dependency(\.kakaoClient) var kakaoClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loginWithKakao:
                return Effect.publisher {
                    kakaoClient
                        .requestOAuthLoginKakao()
                        .map { Action.successKakaoLogin($0) }
                        .catch { Just(Action.failureKakaoLogin($0)) }
                }
                
            case .successKakaoLogin(let response):
                print("로그인 결과: \(response)")
                return .send(.completedLogin)
                
            case .failureKakaoLogin(let error):
                state.alert = AlertState(
                    title: TextState("카카오 로그인 실패"),
                    message: TextState("에러: \(error.localizedDescription)")
                )
                return .none
                
            case .loginWithApple:
                state.alert = AlertState(
                    title: TextState("안내"),
                    message: TextState("Apple 로그인은 준비중입니다.")
                )
                return .none
                
            case .completedLogin:
                return .send(.presentMain)
                
            case .presentMain:
                return .none
                
            case .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
