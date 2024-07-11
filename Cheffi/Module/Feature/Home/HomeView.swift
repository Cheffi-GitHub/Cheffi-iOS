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
        VStack {
            NavigationBarView(type: .normal)
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
        }
    }
}

#Preview {
    HomeView()
}
