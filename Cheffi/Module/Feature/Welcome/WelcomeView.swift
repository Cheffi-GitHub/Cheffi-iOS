//
//  WelcomeView.swift
//  Cheffi
//
//  Created by 이서준 on 10/2/24.
//

import SwiftUI
import ComposableArchitecture

struct WelcomeView: View {
    
    @Perception.Bindable var store: StoreOf<WelcomeFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Spacer()
                    
                    Image(name: Welcome.welcomeCheffi)
                        .resizable()
                        .frame(width: 120, height: 120)
                    
                    Text("가입 완료!")
                        .foregroundStyle(Color.grey9)
                        .font(.suit(.semiBold, 24))
                        .padding(.top, 20)
                    
                    Text("쉐피에 오신걸 환영합니다")
                        .foregroundStyle(Color.grey9)
                        .font(.suit(.regular, 24))
                    
                    Text("게시물 작성 및 맛집 조회를 위해\n프로필 등록이 필요해요")
                        .foregroundStyle(Color.grey7)
                        .font(.suit(.regular, 15))
                        .padding(.top, 16)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
                
                VStack(spacing: 0) {
                    Button(action: {
                        print("Tapped 프로필 등록하기")
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color.primary)
                            
                            Text("프로필 등록하기")
                                .font(.suit(.semiBold, 18))
                                .foregroundStyle(.white)
                        }
                    })
                    .frame(height: 48)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 16)
                    
                    Button(action: {
                        print("Tapped 둘러보기")
                    }, label: {
                        Text("둘러보기")
                            .foregroundStyle(Color.grey4)
                            .font(.suit(.semiBold, 16))
                            .padding(.bottom, 18)
                            .underline()
                    })
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    WelcomeView(store: Store(initialState: WelcomeFeature.State()) {
        WelcomeFeature()
    })
}
