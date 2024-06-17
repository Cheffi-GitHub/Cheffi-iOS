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
            ScrollView(showsIndicators: false) {
                // 인기 급등 맛집
                HomePopularView()
                    .padding(.top, 32)
                
                // 쉐피들의 이야기
                HomeCheffiStoryView()
                    .padding(.top, 48)
                
                // 쉐피들의 인정 맛집
                HomeCheffiPlaceView()
                    .padding(.top, 32)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    NavigationBarView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            // NavigationBar의 shadow 제거
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
