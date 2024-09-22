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
        WithPerceptionTracking {
            ZStack {
                Color.white
                    .edgesIgnoringSafeArea(.all)
                
                RepresentableWebView(url: store.url)
            }
            .ignoresSafeArea(edges: .bottom)
            .toolbar(.hidden)
            .navigationBar(
                title: "",
                leftBarItems: [
                    .backButton {
                        store.send(.dismiss)
                    }
                ]
            )
        }
    }
}

#Preview {
    NavigationStack {
        WebView(store: Store(initialState: WebFeature.State(url: URL(string: "https://www.naver.com")!), reducer: {
            WebFeature()
        }))
    }
}
