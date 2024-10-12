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
    @Dependency(\.continuousClock) var clock
    
    @ObservableState
    struct State: Equatable {
        var totalPage: Int {
            let count = popularReviews.count
            return count > 3 ? min(4, ((count - 4) / 4) + 2) : 1
        }
        var popularReviews: [ReviewModel] = []
        var path = StackState<Path.State>()
        var showTooltip = false
        var presentAddRestaurantView: Bool = false
        var remainTime: Int = 0
    }
    
    enum Action {
        case onFirstAppear
        case startTimer
        case updateTimer
        case sceneActive
        case requestPopularReviews
        case toolTipTapped
        case addRestaurantButtonTapped
        case toggleAddRestaurantView(Bool)
        case popularReviewsResponse(Result<ReviewResponse, CheffiError>)
        case path(StackActionOf<Path>)
    }
    
    var body: some ReducerOf<Self> {
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
                
            case .sceneActive:
                state.remainTime = calculateRemainSeconds()
                return .none
                
            case .requestPopularReviews:
                return Effect.publisher {
                    return networkClient
                        .request(.popularReviews(province: "서울특별시", city: "강남구", cursor: 0, size: 16))
                        .map { Action.popularReviewsResponse(.success($0)) }
                        .catch { Just(Action.popularReviewsResponse(.failure($0))) }
                }
                
            case .addRestaurantButtonTapped:
                state.presentAddRestaurantView = true
                return .none
                
            case .toggleAddRestaurantView(let value):
                state.presentAddRestaurantView = value
                return .none
                
            case .popularReviewsResponse(let response):
                switch response {
                case .success(let result):
                    state.popularReviews = result.data ?? []
                case .failure(let error):
                    print(error)
                }
                return .none
                
            case .toolTipTapped:
                state.showTooltip.toggle()
                return .none
                
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
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
    
    @Reducer(state: .equatable)
    enum Path {
        case moveToReviewDetailView(ReviewDetailFeature)
        case moveToAllReviewView(AllReviewFeature)
    }
}
