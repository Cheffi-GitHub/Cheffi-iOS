//
//  HomeCheffiStoryFeature.swift
//  Cheffi
//
//  Created by 정건호 on 6/5/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HomeCheffiStoryFeature {
    
    @Dependency(\.networkClient) var networkClient
    
    @ObservableState
    struct State: Equatable {
        let itemsPerPage = 3
        var tags: [TagsModel] = [TagsModel(id: 0, name: "한식", type: "FOOD")]
        var selectedTags: [TagsModel: Bool] = [:]
        var recommendList: [RecommendData] = []
        var selectedRecommendList: [RecommendData] = []
        var currentPage = 1
        var totalPage: Int {
            (recommendList.count + itemsPerPage - 1) / itemsPerPage
        }
        
        static let dummy: Self = .init(
            tags: [
                TagsModel(id: 0, name: "한식", type: "FOOD"),
                TagsModel(id: 1, name: "노포", type: "FOOD"),
                TagsModel(id: 2, name: "아시아음식", type: "FOOD"),
                TagsModel(id: 3, name: "매운맛", type: "TASTE"),
                TagsModel(id: 4, name: "달달한맛", type: "TASTE"),
                TagsModel(id: 5, name: "일식", type: "FOOD"),
                TagsModel(id: 6, name: "중식", type: "FOOD")
            ],
            recommendList: [
                RecommendData(title: "정맛집", intro: "안녕하세요 정맛집입니다", isFollowed: true),
                RecommendData(title: "건맛집", intro: "안녕하세요 건맛집입니다", isFollowed: true),
                RecommendData(title: "호맛집", intro: "안녕하세요 호맛집입니다", isFollowed: true),
                RecommendData(title: "한맛집", intro: "안녕하세요 한맛집입니다", isFollowed: true),
                RecommendData(title: "규맛집", intro: "안녕하세요 규맛집입니다", isFollowed: true),
                RecommendData(title: "민맛집", intro: "안녕하세요 민맛집입니다", isFollowed: true),
                RecommendData(title: "이맛집", intro: "안녕하세요 이맛집입니다", isFollowed: true),
                RecommendData(title: "쿵맛집", intro: "안녕하세요 쿵집입니다", isFollowed: true),
                RecommendData(title: "키잌맛집", intro: "안녕하세요 키잌맛집입니다", isFollowed: true),
                RecommendData(title: "석맛집", intro: "안녕하세요 석맛집입니다", isFollowed: true),
                RecommendData(title: "재맛집", intro: "안녕하세요 재맛집입니다", isFollowed: true),
                RecommendData(title: "굿맛집", intro: "안녕하세요 굿맛집입니다", isFollowed: true)
            ]
        )
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onFirstAppear
        case tagTapped(TagsModel)
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
                guard let firstTag = state.tags.first else {
                    print("선택한 태그가 없음")
                    return .none
                }
                state.selectedTags[firstTag] = true
                return .run { send in
                    
                }
                
            case .tagTapped(let tag):
                if state.selectedTags[tag] != nil {
                    state.selectedTags[tag] = nil
                } else {
                    state.selectedTags[tag] = true
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
