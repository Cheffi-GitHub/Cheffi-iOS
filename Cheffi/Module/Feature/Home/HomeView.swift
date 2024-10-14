//
//  HomeView.swift
//  Cheffi
//
//  Created by 정건호 on 6/2/24.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    @Perception.Bindable var store: StoreOf<HomeFeature>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                VStack(spacing: 0) {
                    HomeNavigationBarView(
                        store: StoreOf<HomeNavigationBarFeature>(initialState: HomeNavigationBarFeature.State()) {
                            HomeNavigationBarFeature()
                        },
                        type: .normal
                    )
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
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
            } destination: { store in
                switch store.case {
                case .selectRegion:
                    SelectRegionView()
                case .searchRestaurant:
                    SearchRestaurantsView()
                case .notification:
                    NotificationView()
                case let .reviewDetail(store):
                    ReviewDetailView(store: store)
                case let .allReview(store):
                    AllReviewView(store: store)
                }
            }
        }
    }
}

#Preview {
    let store = Store(initialState: HomeFeature.State()) {
        HomeFeature()
    }

    HomeView(store: store)
}
