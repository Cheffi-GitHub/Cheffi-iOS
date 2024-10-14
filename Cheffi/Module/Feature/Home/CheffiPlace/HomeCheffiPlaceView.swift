//
//  HomeCheffiPlaceView.swift
//  Cheffi
//
//  Created by 정건호 on 6/10/24.
//

import SwiftUI
import ComposableArchitecture

struct HomeCheffiPlaceView: View {
    
    @Perception.Bindable var store: StoreOf<HomeCheffiPlaceFeature> = .init(
        initialState: HomeCheffiPlaceFeature.State()) {
            HomeCheffiPlaceFeature()
        }
    
    @State private var selectedTab: Int = 0
    let tabViewHeight: CGFloat = UIWindow().screen.bounds.height - 284
    
    private let columns = [
        GridItem(.flexible(), alignment: .top),
        GridItem(.flexible(), alignment: .top)
    ]
    
    var body: some View {
        WithPerceptionTracking {
            LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                Section(content: {
                    tabView
                }, header: {
                    VStack(alignment: .leading, spacing: 0) {
                        header
                        categoryScroll
                        Color.g50.frame(height: 2).offset(y: -2)
                            .padding(.bottom, 12)
                    }
                    .background(.white)
                })
            }
            .onFirstAppear {
                store.send(.requestTags)
                store.send(.requestCheffiPlace(tagId: 1))
            }
        }
    }
    
    private var header: some View {
        HStack(spacing: 8) {
            Text("쉐피들의 인정 맛집")
                .foregroundStyle(Color.black)
                .font(.suit(.bold, 20))
            Image(name: Common.info)
                .overlay(
                    Group {
                        if store.state.showTooltip {
                            Image(name: Home.placeTooltip)
                                .offset(x: -60, y: 50)
                        }
                    }
                )
                .onTapGesture {
                    store.send(.toolTipTapped)
                }
        }
        .zIndex(2)
        .padding(.leading, 16)
        .padding(.bottom, 24)
    }
    
    private var categoryScroll: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    WithPerceptionTracking {
                        ForEach(0..<store.state.tags.count, id: \.self) { index in
                            VStack {
                                Text(store.state.tags[index].name)
                                    .foregroundColor(selectedTab == index ? .m100 : .g50)
                                    .font(.suit(.bold, 15))
                                    .frame(maxWidth: .infinity)
                                    .padding(EdgeInsets(top: 10, leading: 16, bottom: 8, trailing: 16))
                                    .onTapGesture {
                                        selectedTab = index
                                    }
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(selectedTab == index ? .red : .clear)
                                    .layoutPriority(1)
                            }
                            .id(index)
                            .onChange(of: selectedTab) { index in
                                withAnimation {
                                    proxy.scrollTo(index, anchor: .center)
                                }
                                store.send(.requestCheffiPlace(tagId: (store.state.tags[index].id)))
                            }
                        }
                    }
                }
            }
        }
        .zIndex(1)
        .padding(.horizontal, 16)
    }
    
    private var tabView: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedTab) {
                ForEach(0..<store.state.tags.count, id: \.self) { index in
                    WithPerceptionTracking {
                        let tagId = store.state.tags[index].id
                        if let reviews = store.state.cheffiPlaceReviews[tagId], !reviews.isEmpty {
                            ScrollView(showsIndicators: false) {
                                LazyVGrid(columns: columns, spacing: 24) {
                                    ForEach(reviews, id: \.id) { review in
                                        ReviewCell(review: review, type: .small)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .tag(index)
                            }
                        } else {
                            VStack(alignment: .center, spacing: 0) {
                                Image(name: Home.homeEmpty)
                                    .padding(.bottom, 12)
                                Text("아직 주변의 \(store.state.tags[index].name) 맛집 리뷰가 없어요\n먼저 주변 아는 맛집을 소개해주세요!")
                                    .font(.suit(.medium, 14))
                                    .foregroundStyle(.g60)
                                    .padding(.bottom, 18)
                                    .multilineTextAlignment(.center)
                                Text("맛집 직접 등록하기")
                                    .font(.suit(.semiBold, 15))
                                    .foregroundStyle(.m100)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 9)
                                    .background(.ms10)
                                    .clipShape(.rect(cornerRadius: 10))
                            }
                        }
                    }
                }
            }
        }
        .frame(height: tabViewHeight)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // TODO: Nested ScrollView 스크롤 버그 수정하기
    }
}

#Preview {
    let store: StoreOf<HomeCheffiPlaceFeature> = StoreOf<HomeCheffiPlaceFeature>(
        initialState: HomeCheffiPlaceFeature.State(
            tags: [
                TagsModel(
                    id: 0,
                    name: "한식",
                    type: "테스트"
                ),
                TagsModel(
                    id: 1,
                    name: "일식",
                    type: "테스트"
                ),
                TagsModel(
                    id: 2,
                    name: "양식",
                    type: "테스트"
                )
            ],
            cheffiPlaceReviews: [
                0: [ReviewModel.dummyData],
                1: [ReviewModel.dummyData, ReviewModel.dummyData],
            ]
        )
    ) {
        HomeCheffiPlaceFeature()
    }
    return HomeCheffiPlaceView(store: store)
}

struct TagType {
    let id: Int
    let name: String
    let type: String
}
