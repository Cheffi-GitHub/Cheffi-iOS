//
//  LaunchScreenView.swift
//  Cheffi
//
//  Created by 이서준 on 6/26/24.
//

import SwiftUI
import ComposableArchitecture

struct LaunchScreenView: View {
    
    @Perception.Bindable var store: StoreOf<LaunchScreenFeature>
    
    var body: some View {
        WithPerceptionTracking {
            ZStack {
                Color.primary
                    .ignoresSafeArea()
                
                Image("launchScreenLogo")
                    .resizable()
                    .frame(width: 120, height: 36)
                    .offset(y: -12.2)
            }
            .onAppear {
                store.send(.onAppear)
            }
            .alert(
                $store.scope(state: \.alert, action: \.alert)
            )
        }
    }
}

#Preview {
    LaunchScreenView(
        store: Store(initialState: LaunchScreenFeature.State()) {
            LaunchScreenFeature()
        }
    )
}
