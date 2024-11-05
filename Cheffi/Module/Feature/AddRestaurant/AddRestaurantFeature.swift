//
//  AddRestaurantFeature.swift
//  Cheffi
//
//  Created by 권승용 on 10/12/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

@Reducer
struct AddRestaurantFeature {
    
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action {
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            }
        }
    }
    
}
