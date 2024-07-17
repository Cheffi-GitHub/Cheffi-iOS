//
//  CheffiApp.swift
//  Cheffi
//
//  Created by 정건호 on 5/28/24.
//

import SwiftUI
import KakaoSDKAuth
import ComposableArchitecture

@main
struct CheffiApp: App {
    
    var body: some Scene {
        WindowGroup {
            // TODO: Navigation (View Transition 설계)
            // RootView로 MainTabView 설정
            // MainTabView에서 FullScreen으로 LaunchScreen Present(With NavigationStack)
            // 회원가입, 프로필 설정 Flow 등등 Push, 모두 완료되면 FullScreen Modal Dismiss
            LaunchScreenView(store: Store(initialState: LaunchScreenFeature.State()) {
                LaunchScreenFeature()
            })
            .onOpenURL { url in
                if AuthApi.isKakaoTalkLoginUrl(url) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
            }
        }
    }
}
