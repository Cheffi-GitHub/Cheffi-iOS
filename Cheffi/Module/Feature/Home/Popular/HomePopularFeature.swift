//
//  HomePopularFeature.swift
//  Cheffi
//
//  Created by 정건호 on 6/3/24.
//

import Foundation
import Alamofire
import Combine
import CombineSchedulers
import ComposableArchitecture

@Reducer
struct HomePopularFeature {
    
    @Dependency(\.networkClient) var networkClient
    @Dependency(\.continuousClock) var clock
    
    @ObservableState
    struct State: Equatable {
        var totalPage: Int {
            let count = popularReviews.count
            return count > 3 ? min(4, ((count - 4) / 4) + 2) : 1
        }
        var popularReviews: [ReviewModel] = []
        var path = StackState<Path.State>()
        var remainTime: Int = 0
    }
    
    enum Action {
        case onFirstAppear
        case startTimer
        case updateTimer
        case requestPopularReviews
        case popularReviewsResponse(Result<ReviewResponse, CheffiError>)
        case toolTipTapped
        case path(StackAction<Path.State, Path.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onFirstAppear:
                return .merge([.send(.startTimer), .send(.requestPopularReviews)])
                
            case .startTimer:
                state.remainTime = calculateRemainSeconds()
                return .run { send in
                    for await _ in self.clock.timer(interval: .seconds(1)) {
                        await send(.updateTimer)
                    }
                }
                
            case .updateTimer:
                if state.remainTime > 0 {
                    state.remainTime -= 1
                } else {
                    state.remainTime = 3600
                    return .send(.requestPopularReviews)
                }
                return .none
                
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
    
    private func calculateRemainSeconds() -> Int {
        let now = Date()
        let calendar = Calendar.current
        let startOfCurrentTime = calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour], from: now)) ?? Date()
        let nextHour = calendar.date(byAdding: .hour, value: 1, to: startOfCurrentTime) ?? Date()
        let seconds = calendar.dateComponents([.second], from: now, to: nextHour).second ?? 0
        return seconds
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
