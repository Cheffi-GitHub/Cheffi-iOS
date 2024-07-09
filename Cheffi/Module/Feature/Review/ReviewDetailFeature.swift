//
//  ReviewDetailFeature.swift
//  Cheffi
//
//  Created by 정건호 on 6/19/24.
//

import Foundation
import Combine
import ComposableArchitecture

@Reducer
struct ReviewDetailFeature {
    
    @Dependency(\.networkClient) var networkClient
    
    @ObservableState
    struct State: Equatable {
        var id: Int?
        var reviewDetail: ReviewDetailModel?
    }
    
    enum Action {
        case requestReviewDetail
        case reviewDetailResponse(Result<ReviewDetailResponse, Error>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .requestReviewDetail:
                return Effect.publisher {
                    return networkClient
                        .request(.reviewDetail(id: state.id ?? 0))
                        .map { Action.reviewDetailResponse(.success($0)) }
                        .catch { Just(Action.reviewDetailResponse(.failure($0))) }
                }
                
            case .reviewDetailResponse(let response):
                switch response {
                case .success(let result):
                    state.reviewDetail = result.data
                case .failure(let error):
                    print(error)
                }
                return .none
            }
        }
    }
}
