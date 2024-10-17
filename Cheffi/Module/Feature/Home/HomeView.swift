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
                        store: store.scope(state: \.navigationBar, action: \.navigationBar), type: .normal
                    )
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            // 인기 급등 맛집
                            HomePopularView(
                                store: store.scope(state: \.popular, action: \.popular)
                            )
                            .padding(.top, 32)
                            
                            // 쉐피들의 이야기
                            HomeCheffiStoryView(
                                store: store.scope(state: \.cheffiStory, action: \.cheffiStory)
                            )
                            .padding(.top, 48)
                            
                            // 쉐피들의 인정 맛집
                            HomeCheffiPlaceView(
                                store: store.scope(state: \.cheffiPlace, action: \.cheffiPlace)
                            )
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
                case let .otherProfile(store):
                    OtherProfileView()
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
