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
    }
    
    enum Action {
        case requestProfile
        case requestProfileResponse(Result<ProfileResponse, Error>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .requestProfile:
                return Effect.publisher {
                    return networkClient
                        .request(.profile(id: state.id))
                        .map { Action.requestProfileResponse(.success($0)) }
                        .catch { Just(Action.requestProfileResponse(.failure($0))) }
                }
                
            case .requestProfileResponse(let response):
                switch response {
                case .success(let result):
                    state.profile = result.data
                case .failure(let error):
                    print(error)
                }
                return .none
            }
        }

    }
}
