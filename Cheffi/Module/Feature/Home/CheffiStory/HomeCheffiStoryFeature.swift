//
//  HomeCheffiStoryFeature.swift
//  Cheffi
//
//  Created by 정건호 on 6/5/24.
//

import Foundation
import ComposableArchitecture

struct CheffiStoryCategory: Hashable, Identifiable, Equatable {
    let id = UUID()
    let name: String
    
    static func == (lhs: CheffiStoryCategory, rhs: CheffiStoryCategory) -> Bool {
        lhs.name == rhs.name
    }
}

@Reducer
struct HomeCheffiStoryFeature {
    
    @ObservableState
    struct State: Equatable {
        let itemsPerPage = 3
        var categories: [CheffiStoryCategory] = [CheffiStoryCategory(name: "한식")]
        var selectedCategories: [CheffiStoryCategory: Bool] = [:]
        var recommendList: [RecommendData] = []
        var currentPage = 1
        var totalPage: Int {
            (recommendList.count + itemsPerPage - 1) / itemsPerPage
        }
        
        static let dummy: Self = .init(
            categories: [
                CheffiStoryCategory(name: "한식"),
                CheffiStoryCategory(name: "노포"),
                CheffiStoryCategory(name: "아시아음식"),
                CheffiStoryCategory(name: "매운맛"),
                CheffiStoryCategory(name: "일식"),
                CheffiStoryCategory(name: "달콤한맛"),
                CheffiStoryCategory(name: "중식")
            ],
            recommendList: [
//                RecommendData(title: "정맛집", intro: "안녕하세요 정맛집입니다", isFollowed: true),
//                RecommendData(title: "건맛집", intro: "안녕하세요 건맛집입니다", isFollowed: true),
//                RecommendData(title: "호맛집", intro: "안녕하세요 호맛집입니다", isFollowed: true),
//                RecommendData(title: "한맛집", intro: "안녕하세요 한맛집입니다", isFollowed: true),
//                RecommendData(title: "규맛집", intro: "안녕하세요 규맛집입니다", isFollowed: true),
//                RecommendData(title: "민맛집", intro: "안녕하세요 민맛집입니다", isFollowed: true),
//                RecommendData(title: "이맛집", intro: "안녕하세요 이맛집입니다", isFollowed: true),
//                RecommendData(title: "쿵맛집", intro: "안녕하세요 쿵집입니다", isFollowed: true),
//                RecommendData(title: "키잌맛집", intro: "안녕하세요 키잌맛집입니다", isFollowed: true),
//                RecommendData(title: "석맛집", intro: "안녕하세요 석맛집입니다", isFollowed: true),
//                RecommendData(title: "재맛집", intro: "안녕하세요 재맛집입니다", isFollowed: true),
//                RecommendData(title: "굿맛집", intro: "안녕하세요 굿맛집입니다", isFollowed: true)
            ]
        )
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onFirstAppear
        case categoryTapped(CheffiStoryCategory)
        case writerRowNavigationAreaTapped
        case previeousPageButtonTapped
        case nextPageButtonTapped
        case followButtonTapped(Int)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .onFirstAppear:
                // 프로필 카테고리 조회 후, 첫 카테고리 넣기
                guard let firstCategory = state.categories.first else {
                    print("서버로부터 전달받은 카테고리 없음")
                    return .none
                }
                state.selectedCategories[firstCategory] = true
                return .run { send in
                    
                }
                
            case .categoryTapped(let category):
                if state.selectedCategories[category] != nil {
                    state.selectedCategories[category] = nil
                } else {
                    state.selectedCategories[category] = true
                }
                // 카테고리에 다라 recommendList 변경
                print("추천 목록 조회 API 호출 후 recommendList에 결과 값 담기")
                return .none
                
            case .writerRowNavigationAreaTapped:
                return .none
                
            case .previeousPageButtonTapped:
                if state.currentPage != 1 {
                    state.currentPage -= 1
                }
                return .none
                
            case .nextPageButtonTapped:
                if state.currentPage != state.totalPage {
                    state.currentPage += 1
                }
                return .none
                
            case .followButtonTapped(let index):
                state.recommendList[index].isFollowed.toggle()
                return .none
            }
        }
    }
}
