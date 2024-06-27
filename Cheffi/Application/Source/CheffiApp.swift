//
//  CheffiApp.swift
//  Cheffi
//
//  Created by 정건호 on 5/28/24.
//

import SwiftUI
import KakaoSDKAuth
import KakaoSDKCommon

@main
struct CheffiApp: App {
    
    init() {
        try? configureKakaoSDK()
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .onOpenURL { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}

extension CheffiApp {
    private func configureKakaoSDK() throws {
        let appKey: String = try AppEnvironment.kakaoNativeAppKey.getValue()
        KakaoSDK.initSDK(appKey: appKey)
    }
}
