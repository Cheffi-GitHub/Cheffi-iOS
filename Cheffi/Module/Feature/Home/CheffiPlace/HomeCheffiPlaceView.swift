//
//  HomeCheffiPlaceView.swift
//  Cheffi
//
//  Created by 권승용 on 10/26/24.
//

import SwiftUI
import ComposableArchitecture

struct HomeCheffiPlaceView: View {
    
    @Perception.Bindable var store: StoreOf<HomeCheffiPlaceFeature>
    
    @State private var selectedTabID = 0
    @State private var isAddRestaurantPresented: Bool = false
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    // 스크롤뷰 높이 = 화면 크기 - (네비게이션 + 타이틀 + 카테고리 높이 + safeArea 높이)
    private var cheffiPlaceScrollViewHeight: CGFloat {
        UIWindow().screen.bounds.height - (156 + safeAreaInsets.top + safeAreaInsets.bottom)
    }
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                header
                    .zIndex(1)
                if !store.tags.isEmpty {
                    tags
                    tabView
                        .frame(height: cheffiPlaceScrollViewHeight)
                } else {
                    tagEmpty
                        .frame(height: cheffiPlaceScrollViewHeight)
                }
            }
            .onFirstAppear {
                store.send(.onFirstAppear)
            }
            .fullScreenCover(isPresented: $isAddRestaurantPresented) {
                AddRestaurantView()
            }
        }
    }
    
    private var header: some View {
        HStack(spacing: 8) {
            Text("쉐피들의 인정 맛집")
                .foregroundStyle(.black)
                .font(.suit(.bold, 20))
                .lineHeight(24, fontHeight: 20)
            Image(name: Common.info)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .overlay {
                    if store.state.showTooltip {
                        Image(name: Home.placeTooltip)
                            .offset(x: -60, y: 50)
                    }
                }
                .onTapGesture {
                    store.send(.toolTipTapped)
                }
            Spacer()
        }
        .padding(.leading, 16)
        .padding(.bottom, 24)
    }
    
    private var tags: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                ForEach(store.tags) { tag in
                    WithPerceptionTracking {
                        Text(tag.name)
                            .font(selectedTabID == tag.id ? .suit(.bold, 15) : .suit(.medium, 15))
                            .foregroundStyle(selectedTabID == tag.id ? .m100 : .g50)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .overlay {
                                VStack {
                                    Spacer()
                                    Rectangle()
                                        .frame(height: 2)
                                        .foregroundStyle(.red)
                                        .opacity(selectedTabID == tag.id ? 1 : 0)
                                }
                            }
                            .onTapGesture {
                                selectedTabID = tag.id
                                store.send(.tagTapped(tag))
                            }
                    }
                }
            }
            .padding(.leading, 16)
            .frame(height: 40)
        }
        .background {
            VStack {
                Spacer()
                Rectangle()
                    .frame(height: 2)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.g10)
            }
        }
    }
    
    private var tabView: some View {
        TabView(selection: $selectedTabID) {
            ForEach(store.tags) { tag in
                WithPerceptionTracking {
                    VStack(spacing: 0) {
                        if let reviewModel = store.cheffiPlaceReviews[tag.id] {
                            ScrollView {
                                LazyVGrid(columns: columns, spacing: 13) {
                                    ForEach(reviewModel) { review in
                                        ReviewCell(review: review, type: .small)
                                            .onTapGesture {
                                                store.send(.reviewCellTapped)
                                            }
                                            .padding(.bottom, 11)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.top, 24)
                            }
                        } else {
                            // TODO: pagination 때문에 생기는 padding 없애기
                            VStack(alignment: .center, spacing: 0) {
                                Image(name: Home.homeEmpty)
                                    .padding(.bottom, 12)
                                Text("아직 주변의 \(tag.name) 맛집 리뷰가 없어요\n먼저 주변 아는 맛집을 소개해주세요!")
                                    .font(.suit(.medium, 14))
                                    .lineHeight(22, fontHeight: 14)
                                    .foregroundStyle(.g60)
                                    .padding(.bottom, 18)
                                    .multilineTextAlignment(.center)
                                Text("맛집 직접 등록하기")
                                    .font(.suit(.semiBold, 15))
                                    .lineHeight(22, fontHeight: 15)
                                    .foregroundStyle(.m100)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 9)
                                    .background(.ms10)
                                    .clipShape(.rect(cornerRadius: 10))
                                    .onTapGesture {
                                        isAddRestaurantPresented = true
                                    }
                            }
                            .padding(.top, 60)
                        }
                        Spacer()
                    }
                    .tag(tag.id)
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    private var tagEmpty: some View {
        Group {
            VStack(alignment: .center, spacing: 0) {
                Image(name: Home.homeEmpty)
                    .padding(.bottom, 12)
                Text("음식 카테고리를 불러오지 못했습니다 ㅠㅠ\n 조금 기다렸다가 다시 시도해 주세요!")
                    .font(.suit(.medium, 14))
                    .lineHeight(22, fontHeight: 14)
                    .foregroundStyle(.g60)
                    .padding(.bottom, 18)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    let store: StoreOf<HomeCheffiPlaceFeature> = StoreOf<HomeCheffiPlaceFeature>(
        initialState: HomeCheffiPlaceFeature.State.dummy
    ) {
        HomeCheffiPlaceFeature()
    }
    return HomeCheffiPlaceView(store: store)
}
