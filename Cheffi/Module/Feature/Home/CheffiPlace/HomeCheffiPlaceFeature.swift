//
//  HomeCheffiPlaceFeature.swift
//  Cheffi
//
//  Created by 정건호 on 6/10/24.
//

import Foundation
import Combine
import ComposableArchitecture
import Perception

@Reducer
struct HomeCheffiPlaceFeature {
    @Dependency(\.networkClient) var networkClient
    
    @ObservableState
    struct State: Equatable {
        var tags: [TagsModel] = []
        var cursors: [Int: Int] = [:]
        var cheffiPlaceReviews: [Int: [ReviewModel]] = [:]
        var showTooltip = false
        
        static let dummy: Self = .init(
            tags: [
                TagsModel(
                    id: 0,
                    name: "한식",
                    type: "테스트"
                ),
                TagsModel(
                    id: 1,
                    name: "양식",
                    type: "테스트"
                ),
                TagsModel(
                    id: 2,
                    name: "일식",
                    type: "테스트"
                )
            ],
            cheffiPlaceReviews: [
                0: [ReviewModel.dummyData, ReviewModel.dummyData, ReviewModel.dummyData],
                1: [ReviewModel.dummyData, ReviewModel.dummyData],
            ]
        )
    }
    
    enum Action {
        case requestTags
        case tagsResponse(Result<TagsResponse, Error>)
        case requestCheffiPlace(cursor: Int = 0, tagId: Int)
        case cheffiPlaceResponse(tagId: Int, Result<ReviewResponse, Error>)
        case toolTipTapped
        case tagTapped
        case reviewCellTapped
        case registerRestaurantButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .requestTags:
                return Effect.publisher {
                    return networkClient
                        .request(.tags(type: "FOOD"))
                        .map { Action.tagsResponse(.success($0)) }
                        .catch { Just(Action.tagsResponse(.failure($0))) }
                }
                
            case let .cheffiPlaceResponse(tagId, .success(response)):
                state.cheffiPlaceReviews[tagId] = response.data ?? []
                return .none
                
            case let .cheffiPlaceResponse(_, .failure(error)):
                print(error)
                return .none
                
            case let .tagsResponse(.success(response)):
                state.tags = response.data ?? []
                return .none
                
            case let .tagsResponse(.failure(error)):
                print(error)
                return .none
                
            case .requestCheffiPlace(let cursor, let tagId):
                return Effect.publisher {
                    return networkClient
                        .request(.cheffiPlace(province: "서울특별시", city: "강남구", cursor: cursor, size: 16, tag_id: tagId))
                        .map { Action.cheffiPlaceResponse(tagId: tagId, .success($0)) }
                        .catch { Just(Action.cheffiPlaceResponse(tagId: tagId, .failure($0))) }
                }
                
            case .toolTipTapped:
                state.showTooltip.toggle()
                return .none
                
            case .tagTapped:
                print("api 호출")
                return .none
                 
            case .reviewCellTapped:
                print("reviewCell 탭")
                return .none
                
            case .registerRestaurantButtonTapped:
                return .none
            }
        }
    }
}
