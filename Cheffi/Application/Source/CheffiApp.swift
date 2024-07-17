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
    
    @StateObject private var appRootManager = AppRootManager()
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appRootManager.currentRoot {
                case .launchScreen:
                    LaunchScreenView(store: Store(initialState: LaunchScreenFeature.State()) {
                        LaunchScreenFeature()
                    })
                    
                case .login:
                    LoginView(store: Store(initialState: LoginFeature.State()) {
                        LoginFeature()
                    })
                    .transition(.opacity.animation(.easeInOut(duration: 0.3)))
                    
                case .main:
                    MainTabView(store: Store(initialState: MainTabFeature.State()) {
                        MainTabFeature()
                    })
                    .transition(.opacity.animation(.easeInOut(duration: 0.3)))
                }
            }
            .onOpenURL { url in
                if AuthApi.isKakaoTalkLoginUrl(url) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
            }
            .background(appRootManager.currentRoot == .login ? .black : .white)
            .environmentObject(appRootManager)
        }
    }
}
