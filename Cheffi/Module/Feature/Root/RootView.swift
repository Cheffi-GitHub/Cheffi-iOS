//
//  RootView.swift
//  Cheffi
//
//  Created by 이서준 on 7/17/24.
//

import SwiftUI
import KakaoSDKAuth
import ComposableArchitecture

struct RootView: View {
    
    @Perception.Bindable var store: StoreOf<RootFeature>
    
    var body: some View {
        WithPerceptionTracking {
            Group {
                switch store.state.currentRoot {
                case .launchScreen:
                    LaunchScreenView(store: store.scope(
                        state: \.launchScreenState,
                        action: \.launchScreenAction
                    ))
                    
                case .authentication:
                    LoginView(store: store.scope(
                        state: \.loginState,
                        action: \.loginAction
                    ))
                    .transition(.opacity.animation(.easeInOut(duration: 0.3)))
                    
                case .main:
                    MainTabView(store: store.scope(
                        state: \.mainTabState,
                        action: \.mainTabAction
                    ))
                    // TODO: 홈 화면으로 좀더 부드럽게 전환되도록 개선할 필요가 있음
                    .transition(.opacity.animation(.easeInOut(duration: 0.3)))
                }
            }
            .onOpenURL { url in
                if AuthApi.isKakaoTalkLoginUrl(url) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
            }
            .background(
                withAnimation(.easeInOut) {
                    store.state.currentRoot == .authentication
                    ? .black
                    : .white
                }
            )
        }
    }
}
