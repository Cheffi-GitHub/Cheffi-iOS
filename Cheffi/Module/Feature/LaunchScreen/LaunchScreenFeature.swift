//
//  LaunchScreenFeature.swift
//  Cheffi
//
//  Created by 이서준 on 6/27/24.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKCommon
import ComposableArchitecture

@Reducer
struct LaunchScreenFeature {
    
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        var completedLaunchScreen: Bool = false
    }
    
    enum Action {
        case onAppear
        case configureKakaoSDK
        case presentAuthentication
        case alert(PresentationAction<Alert>)
        
        enum Alert: Equatable {
            case errorKakaoSocialLogin
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                // TODO: NetworkReachability
                return .send(.configureKakaoSDK)
                
            case .configureKakaoSDK:
                do {
                    try configureKakaoSDK()
                    return .send(.presentAuthentication)
                } catch {
                    // TODO: 기획 문의 후 title, message 문구 변경
                    state.alert = AlertState(
                        title: TextState("안내"),
                        message: TextState("카카오 로그인 기능을 이용할 수 없어요.")
                    )
                    return .none
                }
                
            case .presentAuthentication:
                return .none
                
            case .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

extension LaunchScreenFeature {
    private func configureKakaoSDK() throws {
        let appKey: String = try AppEnvironment.kakaoNativeAppKey.getValue()
        KakaoSDK.initSDK(appKey: appKey)
    }
}
