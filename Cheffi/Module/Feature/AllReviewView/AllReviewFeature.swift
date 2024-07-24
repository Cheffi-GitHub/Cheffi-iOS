//
//  AllReviewFeature.swift
//  Cheffi
//
//  Created by 정건호 on 7/9/24.
//

import Foundation
import Combine
import ComposableArchitecture

@Reducer
struct AllReviewFeature {
    
    @Dependency(\.networkClient) var networkClient
    @Dependency(\.continuousClock) var clock
    
    @ObservableState
    struct State: Equatable {
        var viewType: ReviewViewType = .expand
        var cursor: Int = 1
        var hasNext: Bool = true
        var popularReviews: [ReviewModel]?
        var showTooltip = false
        var remainTime: Int
    }
    
    enum Action {
        case startTimer
        case updateTimer
        case sceneActive
        case changeViewType(type: ReviewViewType)
        case requestPopularReviews
        case popularReviewsResponse(Result<ReviewPagingResponse, Error>)
        case toolTipTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .startTimer:
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
                    state.cursor = 0
                    state.popularReviews = []
                    return .send(.requestPopularReviews)
                }
                return .none
                
            case .sceneActive:
                state.remainTime = calculateRemainSeconds()
                return .none
                
            case .changeViewType(let type):
                state.viewType = type
                return .none
                
            case .requestPopularReviews:
                return Effect.publisher {
                    return networkClient
                        .request(.popularReviews(province: "서울특별시", city: "강남구", cursor: state.cursor, size: 16))
                        .map { Action.popularReviewsResponse(.success($0)) }
                        .catch { Just(Action.popularReviewsResponse(.failure($0))) }
                }
                
            case .popularReviewsResponse(let response):
                switch response {
                case .success(let result):
                    state.cursor += 1
                    state.hasNext = result.hasNext ?? false
                    state.popularReviews = (state.popularReviews ?? []) + (result.data ?? [])
                case .failure(let error):
                    print(error)
                }
                return .none
                
            case .toolTipTapped:
                state.showTooltip.toggle()
                return .none
            }
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
