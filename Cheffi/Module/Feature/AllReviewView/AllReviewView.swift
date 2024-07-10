//
//  AllReviewView.swift
//  Cheffi
//
//  Created by 정건호 on 7/9/24.
//

import SwiftUI
import ComposableArchitecture

struct AllReviewView: View {
    private let store: StoreOf<AllReviewFeature> = .init(
        initialState: AllReviewFeature.State()) {
            AllReviewFeature()
        }
    
    var body: some View {
        Text("전체 리뷰")
    }
}

#Preview {
    AllReviewView()
}
