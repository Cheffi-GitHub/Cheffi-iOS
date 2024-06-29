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

struct HomePopularFeature: Reducer {
    @Dependency(\.homeClient) var homeClient
    
    struct State: Equatable {
        var totalPage: Int {
            let count = popularReviews.count
            return count > 3 ? min(4, ((count - 4) / 4) + 2) : 1
        }
        var popularReviews: [PopularReviewModel] = []
    }
    
    enum Action {
        case requestPopularReviews
        case popularReviewsResponse(Result<PopularReviewResponse, Error>)
        case toolTipTapped
        case viewAllTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .requestPopularReviews:
                return .run { send in
                    do {
                        let reviews = try await homeClient.popularReviews("서울특별시", "강남구", 0, 16)
                        await send(.popularReviewsResponse(.success(reviews)))
                    } catch {
                        await send(.popularReviewsResponse(.failure(error)))
                    }
                }
            case let .popularReviewsResponse(.success(response)):
                state.popularReviews = response.data ?? []
                return .none
                
            case let .popularReviewsResponse(.failure(error)):
                print(error)
                return .none
                
            case .toolTipTapped:
                print("툴팁 보여주기")
                return .none
            case .viewAllTapped:
                print("전체보기 화면 이동")
                return .none
            }
        }
    }
}
