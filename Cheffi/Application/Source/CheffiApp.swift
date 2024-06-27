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
