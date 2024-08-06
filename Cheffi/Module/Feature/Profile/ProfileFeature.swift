//
//  ProfileFeature.swift
//  Cheffi
//
//  Created by 정건호 on 7/29/24.
//

import Foundation
import Combine
import ComposableArchitecture

@Reducer
struct ProfileFeature {
    
    @Dependency(\.networkClient) var networkClient
    
    @ObservableState
    struct State: Equatable {
        var id: Int = 1
        var profile: ProfileModel?
        var reviews: [ReviewModel]?
        var reviewsHasNext: Bool?
        var reviewsNext: Int?
    }
    
    enum Action {
        case onFirstAppear
        
        case requestProfile
        case requestReviews
        
        case requestProfileResponse(Result<ProfileResponse, CheffiError>)
        case requestReviewsResponse(Result<ReviewPagingResponse, CheffiError>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onFirstAppear:
                return .merge([ .send(.requestProfile), .send(.requestReviews)])
                
            case .requestProfile:
                return Effect.publisher {
                    return networkClient
                        .request(.profile(id: String(state.id)))
                        .map { Action.requestProfileResponse(.success($0)) }
                        .catch { Just(Action.requestProfileResponse(.failure($0))) }
                }
                
            case .requestReviews:
                return Effect.publisher {
                    return networkClient
                        .request(.profileReviews(id: String(state.id), cursor: state.reviewsNext, size: 16))
                        .map { Action.requestReviewsResponse(.success($0)) }
                        .catch { Just(Action.requestReviewsResponse(.failure($0))) }
                }
                
            case .requestProfileResponse(let response):
                switch response {
                case .success(let result):
                    state.profile = result.data
                case .failure(let error):
                    print(error)
                }
                return .none
                
            case .requestReviewsResponse(let response):
                switch response {
                case .success(let result):
                    if state.reviews == nil {
                        state.reviews = result.data ?? []
                    } else {
                        state.reviews?.append(contentsOf: result.data ?? [])
                    }
                    state.reviewsHasNext = result.hasNext
                    state.reviewsNext = result.next
                case .failure(let error):
                    print(error)
                }
                return .none
            }
        }
    }
}
