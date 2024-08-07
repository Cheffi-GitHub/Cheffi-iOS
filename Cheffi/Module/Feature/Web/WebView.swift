//
//  WebView.swift
//  Cheffi
//
//  Created by 이서준 on 8/7/24.
//

import SwiftUI
import ComposableArchitecture

struct WebView: View {
    
    @Perception.Bindable var store: StoreOf<WebFeature>
    
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                ZStack {
                    HStack {
                        Button(action: {
                            // TODO: 공통 Custom NavigationBar ViewModifier 생성
                        }) {
                            Image(name: Common.leftArrow)
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.black)
                        }
                        .buttonStyle(.plain)
                        .padding(.leading, 16)
                        
                        Spacer()
                    }
                    
                    Text(store.title)
                        .font(.suit(.semiBold, 16))
                        .foregroundStyle(.black)
                }
                .background(.white)
                .frame(height: 44)
                
                RepresentableWebView(url: store.url)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .toolbar(.hidden)
    }
}

#Preview {
    NavigationStack {
        WebView(store: Store(initialState: WebFeature.State(url: URL(string: "https://www.naver.com")!), reducer: {
            WebFeature()
        }))
    }
}
