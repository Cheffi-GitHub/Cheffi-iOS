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
    }
    
    enum Action {
        case requestTags
        case tagsResponse(Result<TagsResponse, Error>)
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
            case let .tagsResponse(.success(response)):
                state.tags = response.data ?? []
                return .none
            case let .tagsResponse(.failure(error)):
                print(error)
                return .none
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
