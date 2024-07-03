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
    @Dependency(\.networkClient) var networkClient
    
    struct State: Equatable {
        var totalPage: Int {
            let count = popularReviews.count
            return count > 3 ? min(4, ((count - 4) / 4) + 2) : 1
        }
        var popularReviews: [ReviewModel] = []
    }
    
    enum Action {
        case requestPopularReviews
        case popularReviewsResponse(Result<ReviewResponse, AFError>)
        case toolTipTapped
        case viewAllTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .requestPopularReviews:
                return .publisher {
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
                
            case .viewAllTapped:
                print("전체보기 화면 이동")
                return .none
            }
        }
    }
}
