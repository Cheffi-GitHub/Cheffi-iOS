//
//  LoginFeature.swift
//  Cheffi
//
//  Created by 이서준 on 7/13/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct LoginFeature {
    
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action {
        case onAppear
        case completedLogin
        case presentMain
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    // FIXME: 로그인 없이 임시로 1초뒤에 메인화면으로 이동
                    try await Task.sleep(for: .seconds(1))
                    await send(.completedLogin)
                }
                
            case .completedLogin:
                return .send(.presentMain)
                
            case .presentMain:
                return .none
            }
        }
    }
}
