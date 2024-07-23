//
//  LoginView.swift
//  Cheffi
//
//  Created by 이서준 on 6/17/24.
//

import SwiftUI
import ComposableArchitecture

struct LoginView: View {
    
    @Perception.Bindable var store: StoreOf<LoginFeature>
    
    var body: some View {
        WithPerceptionTracking {
            ZStack {
                Image(name: Login.loginBackgroundImage)
                    .resizable()
                
                VStack(alignment: .leading, spacing: .zero) {
                    HStack {
                        Text("Cheffi")
                            .foregroundStyle(.white)
                            .font(.suit(.bold, 20))
                            .padding(.top, 80)
                            .padding(.leading, 24)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    Image(name: Login.loginServiceOverview)
                        .resizable()
                        .frame(width: 267, height: 108)
                        .padding(.leading, 24)
                        .padding(.bottom, 16)
                    
                    Text("내가 몰랐던.\n공유하고 싶었던.\n이 세상 모든 맛집 정보")
                        .foregroundStyle(.white)
                        .font(.suit(.medium, 16))
                        .padding(.leading, 24)
                        .padding(.bottom, 128)
                    
                    Button(action: {
                        store.send(.loginWithKakao)
                    }, label: {
                        Image(name: Login.loginKakao)
                    })
                    .frame(height: 56)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                    
                    Button(action: {
                        store.send(.loginWithApple)
                    }, label: {
                        Image(name: Login.loginApple)
                    })
                    .padding(.horizontal, 16)
                    .frame(height: 56)
                    
                }
                .padding(.bottom, 88)
                
            }
            .ignoresSafeArea()
            .alert(
                $store.scope(state: \.alert, action: \.alert)
            )
        }
    }
}

#Preview {
    LoginView(
        store: Store(initialState: LoginFeature.State()) {
            LoginFeature()
        }
    )
}
