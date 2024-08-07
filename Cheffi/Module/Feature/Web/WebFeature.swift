//
//  WebFeature.swift
//  Cheffi
//
//  Created by 이서준 on 8/7/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct WebFeature {
    
    @ObservableState
    struct State: Equatable {
        let url: URL
        var title: String
        
        init(url: URL, title: String = "") {
            self.url = url
            self.title = title
        }
    }
    
    enum Action {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}
