//
//  HomeFeature.swift
//  Cheffi
//
//  Created by 권승용 on 10/13/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HomeFeature {
    @ObservableState
    struct State: Equatable {
        var navigationBar = HomeNavigationBarFeature.State()
        var popular = HomePopularFeature.State()
        var cheffiStory = HomeCheffiStoryFeature.State()
        var cheffiPlace = HomeCheffiPlaceFeature.State()
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case navigationBar(HomeNavigationBarFeature.Action)
        case popular(HomePopularFeature.Action)
        case cheffiStory(HomeCheffiStoryFeature.Action)
        case cheffiPlace(HomeCheffiPlaceFeature.Action)
        case path(StackActionOf<Path>)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.navigationBar, action: \.navigationBar) {
            HomeNavigationBarFeature()
        }
        Scope(state: \.popular, action: \.popular) {
            HomePopularFeature()
        }
        Scope(state: \.cheffiStory, action: \.cheffiStory) {
            HomeCheffiStoryFeature()
        }
        Scope(state: \.cheffiPlace, action: \.cheffiPlace) {
            HomeCheffiPlaceFeature()
        }
        .forEach(\.path, action: \.path)
    }
}

extension HomeFeature {
    
    @Reducer(state: .equatable)
    enum Path {
        case selectRegion
        case searchRestaurant
        case notification
        case reviewDetail(ReviewDetailFeature)
        case allReview(AllReviewFeature)
        case otherProfile(OtherProfileFeature)
    }
}
