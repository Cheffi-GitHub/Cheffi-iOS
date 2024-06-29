//
//  HomeCheffiPlaceFeature.swift
//  Cheffi
//
//  Created by 정건호 on 6/10/24.
//

import Foundation
import ComposableArchitecture

struct HomeCheffiPlaceFeature: Reducer {
    @Dependency(\.homeClient) var homeClient
    
    struct State: Equatable {
        var tags: [TagsModel] = []
        var cursors: [Int: Int] = [:]
        var cheffiPlaceReviews: [Int: [ReviewModel]] = [:]
    }
    
    enum Action {
        case requestTags
        case tagsResponse(Result<TagsResponse, Error>)
        case requestCheffiPlace(cursor: Int = 0, tagId: Int)
        case cheffiPlaceResponse(tagId: Int, Result<ReviewResponse, Error>)
        case toolTipTapped
        case tagTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .requestTags:
                return .run { send in
                    do {
                        let tags = try await homeClient.tags("FOOD")
                        await send(.tagsResponse(.success(tags)))
                    } catch {
                        await send(.tagsResponse(.failure(error)))
                    }
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
                return .run { send in
                    do {
                        let reviews = try await homeClient.cheffiPlaceReviews("서울특별시", "강남구", cursor, 16, tagId)
                        await send(.cheffiPlaceResponse(tagId: tagId, .success(reviews)))
                    } catch {
                        await send(.cheffiPlaceResponse(tagId: tagId, .failure(error)))
                    }
                }
            case .toolTipTapped:
                print("툴팁 보여주기")
                return .none
            case .tagTapped:
                print("api 호출")
                return .none
            }
        }
    }
}
