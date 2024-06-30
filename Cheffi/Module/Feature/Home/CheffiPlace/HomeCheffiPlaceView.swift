//
//  HomeCheffiPlaceView.swift
//  Cheffi
//
//  Created by 정건호 on 6/10/24.
//

import SwiftUI
import ComposableArchitecture

struct HomeCheffiPlaceView: View {
    
    private let store: StoreOf<HomeCheffiPlaceFeature> = .init(
        initialState: HomeCheffiPlaceFeature.State()) {
            HomeCheffiPlaceFeature()
        }
    
    @State private var selectedTab: Int = 0
    @State private var tabViewHeight: CGFloat = UIWindow().screen.bounds.height - 284
    
    private let columns = [
        GridItem(.flexible(), alignment: .top),
        GridItem(.flexible(), alignment: .top)
    ]
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                Section(content: {
                    VStack(spacing: 0) {
                        TabView(selection: $selectedTab) {
                            ForEach(0..<viewStore.state.tags.count, id: \.self) { index in
                                let tagId = viewStore.state.tags[index].id
                                if let reviews = viewStore.state.cheffiPlaceReviews[tagId], !reviews.isEmpty {
                                    ScrollView(showsIndicators: false) {
                                        LazyVGrid(columns: columns, spacing: 24) {
                                            ForEach(reviews, id: \.id) { review in
                                                PlaceCell(review: review, type: .small)
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                        .tag(index)
                                    }
                                } else {
                                    VStack(alignment: .center, spacing: 0) {
                                        Image(name: Home.homeEmpty)
                                            .padding(.bottom, 12)
                                        Text("아직 주변의 \(viewStore.state.tags[index].name) 맛집 리뷰가 없어요\n먼저 주변 아는 맛집을 소개해주세요!")
                                            .font(.suit(.medium, 14))
                                            .foregroundStyle(Color.grey6)
                                            .padding(.bottom, 18)
                                            .multilineTextAlignment(.center)
                                        Text("맛집 직접 등록하기")
                                            .font(.suit(.semiBold, 15))
                                            .foregroundStyle(Color.primary)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 9)
                                            .background(Color.background)
                                            .clipShape(.rect(cornerRadius: 10))
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: tabViewHeight)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // TODO: Nested ScrollView 스크롤 버그 수정하기
                }, header: {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 8) {
                            Text("쉐피들의 인정 맛집")
                                .foregroundStyle(Color.black)
                                .font(.suit(.bold, 20))
                            Image(name: Common.info)
                        }
                        .padding(.leading, 16)
                        .padding(.bottom, 24)
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 0) {
                                    ForEach(0..<viewStore.state.tags.count, id: \.self) { index in
                                        VStack {
                                            Text(viewStore.state.tags[index].name)
                                                .foregroundColor(selectedTab == index ? Color.primary : Color.grey5)
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
                                            viewStore.send(.requestCheffiPlace(tagId: (viewStore.state.tags[index].id)))
                                        }
                                    }
                                }
                            }
                        }
                        .zIndex(1)
                        .padding(.horizontal, 16)
                        
                        Color.grey05.frame(height: 2).offset(y: -2)
                            .padding(.bottom, 12)
                    }
                    .background(Color.white)
                })
            }
            .onAppear {
                viewStore.send(.requestTags)
                viewStore.send(.requestCheffiPlace(tagId: 1))
            }
        }
    }
}

#Preview {
    HomeCheffiPlaceView()
}

struct TagType {
    let id: Int
    let name: String
    let type: String
}
