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
        case onFirstAppear
        
        case tagTapped(TagsModel)
        case toolTipTapped
        case reviewCellTapped
        case registerRestaurantButtonTapped
        
        case requestTags
        case tagsResponse(Result<TagsResponse, Error>)
        case requestCheffiPlace(cursor: Int = 0, tagId: Int)
        case cheffiPlaceResponse(tagId: Int, Result<ReviewResponse, Error>)
    }
    
    // TODO: 무한 스크롤 기능 구현 필요
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
                // MARK: - Life Cycle
            case .onFirstAppear:
                return .run { send in
                    await send(.requestTags)
                }
                
                // MARK: - User Interaction
            case .toolTipTapped:
                state.showTooltip.toggle()
                return .none
                
            case let .tagTapped(tag):
                return .run { send in
                    await send(.requestCheffiPlace(cursor: 0, tagId: tag.id))
                }
                
            case .reviewCellTapped:
                print("reviewCell 탭")
                return .none
                
            case .registerRestaurantButtonTapped:
                return .none
                
                // MARK: - Network
            case .requestTags:
                return Effect.publisher {
                    return networkClient
                        .request(.tags(type: "FOOD"))
                        .map { Action.tagsResponse(.success($0)) }
                        .catch { Just(Action.tagsResponse(.failure($0))) }
                }
                
            case let .tagsResponse(response):
                switch response {
                case .success(let response):
                    state.tags = response.data ?? []
                    guard !state.tags.isEmpty else {
                        return .none
                    }
                    let requestTag = state.tags[0]
                    return .run { send in
                        await send(.requestCheffiPlace(cursor: 0, tagId: requestTag.id))
                    }
                    
                case .failure(let error):
                    print(error)
                    return .none
                }
                
            case .requestCheffiPlace(let cursor, let tagId):
                return Effect.publisher {
                    return networkClient
                    // TODO: 위치 서비스에서 받아온 정보를 통해 province / city 제공
                        .request(.cheffiPlace(province: "서울특별시", city: "강남구", cursor: cursor, size: 16, tag_id: tagId))
                        .map { Action.cheffiPlaceResponse(tagId: tagId, .success($0)) }
                        .catch { Just(Action.cheffiPlaceResponse(tagId: tagId, .failure($0))) }
                }
                
            case let .cheffiPlaceResponse(tagId, response):
                switch response {
                case .success(let response):
                    state.cheffiPlaceReviews[tagId] = response.data ?? []
                    return .none
                    
                case .failure(let error):
                    print(error)
                    return .none
                }
            }
        }
    }
}
