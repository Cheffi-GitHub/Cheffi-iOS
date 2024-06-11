//
//  HomeCheffiStoryFeature.swift
//  Cheffi
//
//  Created by 정건호 on 6/5/24.
//

import Foundation
import ComposableArchitecture

struct HomeCheffiStoryFeature: Reducer {
    
    struct State: Equatable {
        var selectedCategories: [String] = []
        var recommendList: [RecommendData] = []
    }
    
    enum Action: Equatable {
        case onAppear
        case categoryTapped(String)
        case followTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                // 프로필 카테고리 조회 후, 첫 카테고리 넣기
                state.selectedCategories.append("한식")
                return .none
            case .categoryTapped(let category):
                if state.selectedCategories.contains(category) {
                    state.selectedCategories.removeAll { $0 == category }
                } else {
                    state.selectedCategories.append(category)
                }
                print("추천 목록 조회 API 호출 후 recommendList에 결과 값 담기")
                return .none
            case .followTapped:
                print("팔로우 이벤트")
                return .none
            }
        }
    }
}
