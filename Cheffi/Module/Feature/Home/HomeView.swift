//
//  HomeView.swift
//  Cheffi
//
//  Created by 정건호 on 6/2/24.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                HomePopularView()
            }
        }
        .onAppear {
            let appearace = UINavigationBarAppearance()
            appearace.shadowColor = .clear
            appearace.backgroundColor = .white
            UINavigationBar.appearance().standardAppearance = appearace
            UINavigationBar.appearance().scrollEdgeAppearance = appearace
        }
    }
}

#Preview {
    HomeView()
}
