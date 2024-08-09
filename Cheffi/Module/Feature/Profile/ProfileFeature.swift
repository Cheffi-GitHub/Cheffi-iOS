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
        var purchase: [ReviewModel]?
        var bookmarks: [ReviewModel]?
        
        var reviewsHasNext: Bool?
        var reviewsNext: Int?
        var purchaseHasNext: Bool?
        var purchaseNext: Int?
        var bookmarksHasNext: Bool?
        var bookmarksNext: Int?
    }
    
    enum Action {
        case onFirstAppear
        
        case requestProfile
        case requestReviews
        case requestPurchase
        case requestBookmarks
        
        case requestProfileResponse(Result<ProfileResponse, CheffiError>)
        case requestReviewsResponse(Result<ReviewPagingResponse, CheffiError>)
        case requestPurchaseResponse(Result<ReviewPagingResponse, CheffiError>)
        case requestBookmarksResponse(Result<ReviewPagingResponse, CheffiError>)
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
                
            case .requestPurchase:
                return Effect.publisher {
                    return networkClient
                        .request(.profilePurchase(id: String(state.id), cursor: state.purchaseNext, size: 16))
                        .map { Action.requestPurchaseResponse(.success($0)) }
                        .catch { Just(Action.requestPurchaseResponse(.failure($0))) }
                }
                
            case .requestBookmarks:
                return Effect.publisher {
                    return networkClient
                        .request(.profileBookmarks(id: String(state.id), cursor: state.bookmarksNext, size: 16))
                        .map { Action.requestBookmarksResponse(.success($0)) }
                        .catch { Just(Action.requestBookmarksResponse(.failure($0))) }
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
                
            case .requestPurchaseResponse(let response):
                switch response {
                case .success(let result):
                    if state.purchase == nil {
                        state.purchase = result.data ?? []
                    } else {
                        state.purchase?.append(contentsOf: result.data ?? [])
                    }
                    state.purchaseHasNext = result.hasNext
                    state.purchaseNext = result.next
                case .failure(let error):
                    print(error)
                }
                return .none
                
            case .requestBookmarksResponse(let response):
                switch response {
                case .success(let result):
                    if state.bookmarks == nil {
                        state.bookmarks = result.data ?? []
                    } else {
                        state.bookmarks?.append(contentsOf: result.data ?? [])
                    }
                    state.bookmarksHasNext = result.hasNext
                    state.bookmarksNext = result.next
                case .failure(let error):
                    print(error)
                }
                return .none
            }
        }
    }
}
