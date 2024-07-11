//
//  HomePopularFeature.swift
//  Cheffi
//
//  Created by 정건호 on 6/3/24.
//

import Foundation
import Alamofire
import Combine
import ComposableArchitecture

@Reducer
struct HomePopularFeature {
    
    @Dependency(\.networkClient) var networkClient
    
    @ObservableState
    struct State: Equatable {
        var totalPage: Int {
            let count = popularReviews.count
            return count > 3 ? min(4, ((count - 4) / 4) + 2) : 1
        }
        var popularReviews: [ReviewModel] = []
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case requestPopularReviews
        case popularReviewsResponse(Result<ReviewResponse, CheffiError>)
        case toolTipTapped
        case path(StackAction<Path.State, Path.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .requestPopularReviews:
                return Effect.publisher {
                    return networkClient
                        .request(.popularReviews(province: "서울특별시", city: "강남구", cursor: 0, size: 16))
                        .map { Action.popularReviewsResponse(.success($0)) }
                        .catch { Just(Action.popularReviewsResponse(.failure($0))) }
                }
                
            case .popularReviewsResponse(let response):
                switch response {
                case .success(let result):
                    state.popularReviews = result.data ?? []
                case .failure(let error):
                    print(error)
                }
                return .none
                
            case .toolTipTapped:
                print("툴팁 보여주기")
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
}

extension HomePopularFeature {
    @Reducer
    struct Path {
        @ObservableState
        enum State: Equatable {
            case moveToReviewDetailView(ReviewDetailFeature.State)
            case moveToAllReviewView(AllReviewFeature.State)
        }
        
        enum Action {
            case moveToReviewDetailView(ReviewDetailFeature.Action)
            case moveToAllReviewView(AllReviewFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.moveToReviewDetailView, action: /Action.moveToReviewDetailView) {
                ReviewDetailFeature()
            }
            Scope(state: /State.moveToAllReviewView, action: /Action.moveToAllReviewView) {
                AllReviewFeature()
            }
        }
    }
}
