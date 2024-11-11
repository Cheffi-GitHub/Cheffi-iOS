//
//  HomeCheffiStoryFeature.swift
//  Cheffi
//
//  Created by 정건호 on 6/5/24.
//

import Foundation
import ComposableArchitecture
import Combine


@Reducer
struct HomeCheffiStoryFeature {
    
    @Dependency(\.networkClient) var networkClient
    
    @ObservableState
    struct State: Equatable {
        let itemsPerPage = 3
        var tags: [TagsModel] = [TagsModel(id: 0, name: "한식", type: "FOOD")]
        var selectedTags: [TagsModel: Bool] = [:]
        var recommendedFollowers: [RecommendedFollower] = []
        var currentPage = 1
        var totalPage: Int {
            (recommendedFollowers.count + itemsPerPage - 1) / itemsPerPage
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
            recommendedFollowers: [
                RecommendedFollower(
                    id: 0,
                    nickname: "정맛집",
                    photo: PhotoInfo(
                        url: nil,
                        width: nil,
                        height: nil
                    ),
                    instruction: "안녕하세요 정맛집 입니다",
                    followers: 16,
                    isFollowed: false
                ),
                RecommendedFollower(
                    id: 1,
                    nickname: "호맛집",
                    photo: PhotoInfo(
                        url: nil,
                        width: nil,
                        height: nil
                    ),
                    instruction: "안녕하세요 호맛집 입니다",
                    followers: 16,
                    isFollowed: true
                ),
                RecommendedFollower(
                    id: 2,
                    nickname: "후맛집",
                    photo: PhotoInfo(
                        url: nil,
                        width: nil,
                        height: nil
                    ),
                    instruction: "안녕하세요 후맛집 입니다",
                    followers: 16,
                    isFollowed: false
                ),
                RecommendedFollower(
                    id: 3,
                    nickname: "하맛집",
                    photo: PhotoInfo(
                        url: nil,
                        width: nil,
                        height: nil
                    ),
                    instruction: "안녕하세요 하맛집 입니다",
                    followers: 16,
                    isFollowed: false
                )
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
        case recommendedFollowersForTagsRequest([Int])
        case recommendedFollowersForTagsResponse(Result<[RecommendedFollower], Error>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            // MARK: - Life Cycle
            case .onFirstAppear:
                // TODO: 마이페이지 정보에서 조회한 태그 정보 가져와서, request 하기
                guard let firstTag = state.tags.first else {
                    print("선택한 태그가 없음")
                    return .none
                }
                state.selectedTags[firstTag] = true
                return .run { send in
                    await send(.recommendedFollowersForTagsRequest([firstTag.id]))
                }

            // MARK: - User Interaction
            case .tagTapped(let tag):
                if state.selectedTags[tag] != nil {
                    state.selectedTags[tag] = nil
                } else {
                    state.selectedTags[tag] = true
                }
                let tagIDs = Array(state.selectedTags.keys.map { $0.id })
                return .run { send in
                    await send(.recommendedFollowersForTagsRequest(tagIDs))
                }
                
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
                state.recommendedFollowers[index].isFollowed.toggle()
                return .none
                
            // MARK: - Network
            case let .recommendedFollowersForTagsRequest(tagIDs):
                return Effect.publisher {
                    return networkClient
                        .request(
                            .recommendedFollowsForTags(tagid: tagIDs)
                        )
                        .map { Action.recommendedFollowersForTagsResponse(.success($0)) }
                        .catch { Just(Action.recommendedFollowersForTagsResponse(.failure($0))) }
                }
                
            case let .recommendedFollowersForTagsResponse(response):
                switch response {
                case .success(let data):
                    state.recommendedFollowers = data
                    
                case .failure(let error):
                    print(error)
                }
                return .none
            }
        }
    }
}
