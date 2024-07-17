//
//  CheffiApp.swift
//  Cheffi
//
//  Created by 정건호 on 5/28/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct CheffiApp: App {
    
    var body: some Scene {
        WindowGroup {
            RootView(store: Store(initialState: RootFeature.State()) {
                RootFeature()
            })
        }
    }
}
