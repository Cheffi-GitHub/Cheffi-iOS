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
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case loginWithKakao
        case successKakaoLogin(LoginKakaoResponse)
        case failureKakaoLogin(KakaoAuthError)
        case loginWithApple
        case completedLogin
        case presentMain
        case alert(PresentationAction<Alert>)
        case path(StackActionOf<Path>)
        
        enum Alert: Equatable {
            case notReadyAppleLogin
        }
    }
    
    @Reducer(state: .equatable)
    enum Path {
        case navigateToTerms(TermsFeature)
        //case navigateToTermsWeb
    }
    
    @Dependency(\.kakaoClient) var kakaoClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loginWithKakao:
                return Effect.publisher {
                    kakaoClient
                        .requestManualLogin()
                        .map { Action.successKakaoLogin($0) }
                        .catch { Just(Action.failureKakaoLogin($0)) }
                }
                
            case .successKakaoLogin(let response):
                if response.data?.isNewUser ?? false {
                    state.path.append(.navigateToTerms(TermsFeature.State()))
                    return .none
                } else {
                    return .send(.completedLogin)
                }
                
            case .failureKakaoLogin(let error):
                state.alert = AlertState(
                    title: TextState("카카오 로그인 실패"),
                    message: TextState("에러: \(error.localizedDescription)")
                )
                return .none
                
            case .loginWithApple:
                state.path.append(.navigateToTerms(TermsFeature.State()))
                return .none
                
                // FIXME: 약관 화면 개발을 위한 신규 유저 체크 비활성화
                //state.alert = AlertState(
                //    title: TextState("안내"),
                //    message: TextState("Apple 로그인은 준비중입니다.")
                //)
                //return .none
                
            case .completedLogin:
                return .send(.presentMain)
                
            case .presentMain:
                return .none
                
            case .alert:
                return .none
                
            case .path:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
        .forEach(\.path, action: \.path)
    }
}
