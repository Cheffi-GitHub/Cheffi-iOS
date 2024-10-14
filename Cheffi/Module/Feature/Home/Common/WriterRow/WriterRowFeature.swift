//
//  WriterRowFeature.swift
//  Cheffi
//
//  Created by 권승용 on 10/14/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct WriterRowFeature {
    @ObservableState
    struct State {
        var photoUrl: String?
        var title: String
        var intro: String
        var isFollowed: Bool
    }
    
    enum Action {
        case profileImageTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .profileImageTapped:
                print("Tapped")
                return .none
            }
        }
    }
}
