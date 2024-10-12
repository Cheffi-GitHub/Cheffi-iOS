//
//  HomePopularView.swift
//  Cheffi
//
//  Created by 정건호 on 6/3/24.
//

import SwiftUI
import ComposableArchitecture

struct HomePopularView: View {
    
    @Perception.Bindable var store: StoreOf<HomePopularFeature> = .init(
        initialState: HomePopularFeature.State()) {
            HomePopularFeature()
        }
    @Environment(\.scenePhase) var scenePhase
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State private var currentpage = 1
    
    var body: some View {
        WithPerceptionTracking {
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                VStack(spacing: 0) {
                    headline
                    if store.popularReviews.count == 0 {
                        reviewEmpty
                            .padding(.top, 40)
                    } else {
                        timeIndicator
                            .zIndex(1)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 24)
                            .padding(.top, 16)
                        tabView
                        paging
                    }
                }
                .onChange(of: scenePhase) { state in
                    switch state {
                    case .active: store.send(.sceneActive)
                    case .inactive: break
                    case .background: break
                    default: break
                    }
                }
                .onFirstAppear {
                    store.send(.onFirstAppear)
                }
            } destination: { store in
                switch store.case {
                case .moveToReviewDetailView(let store):
                    ReviewDetailView(store: store)
                case .moveToAllReviewView(let store):
                    AllReviewView(store: store)
                }
            }
        }
        .fullScreenCover(isPresented: $store.presentAddRestaurantView.sending(\.toggleAddRestaurantView)) {
            AddRestaurantView()
        }
    }
    
    private var headline: some View {
        HStack {
            Text("인기 급등 맛집")
                .foregroundStyle(.black)
                .font(.suit(.bold, 20))
                .lineHeight(22, fontHeight: 20)
                .padding(.leading, 16)
            Spacer()
        }
    }
    
    private var reviewEmpty: some View {
        VStack(alignment: .center, spacing: 0) {
            Image(name: Home.homeEmpty)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding(.bottom, 12)
            Text("아직 주변의 맛집 리뷰가 없어요\n먼저 주변 아는 맛집을 소개해주세요!")
                .font(.suit(.medium, 14))
                .foregroundStyle(Color.grey6)
                .lineHeight(22, fontHeight: 14)
                .padding(.bottom, 18)
                .multilineTextAlignment(.center)
            Text("맛집 직접 등록하기")
                .font(.suit(.semiBold, 15))
                .foregroundStyle(Color.primary)
                .lineHeight(22, fontHeight: 15)
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(Color.background)
                .clipShape(.rect(cornerRadius: 10))
                .onTapGesture {
                    store.send(.addRestaurantButtonTapped)
                }
        }
    }
    
    private var timeIndicator: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Image(name: Common.clock)
                Text(store.remainTime.toHourMinuteSecond())
                    .foregroundStyle(Color.primary)
                    .font(.suit(.bold, 18))
                Text("초 뒤에")
                    .foregroundStyle(.black)
                    .font(.suit(.bold, 18))
            }
            HStack(spacing: 4) {
                Text("인기 급등 맛집이 변경돼요.")
                    .foregroundStyle(Color.black)
                    .font(.suit(.regular, 18))
                Image(name: Common.info)
                    .overlay(
                        Group {
                            if store.state.showTooltip {
                                Image(name: Home.popularTooptip)
                                    .offset(x: -60, y: 50)
                            }
                        }
                    )
                    .onTapGesture {
                        // TODO: 다른 영역 탭 시에도 툴팁 사라지는 기능 구현 필요
                        store.send(.toolTipTapped)
                    }
                Spacer()
                NavigationLink(state: HomePopularFeature.Path.State.moveToAllReviewView(
                    .init(popularReviews: store.popularReviews, remainTime: store.remainTime)
                )) {
                    HStack {
                        // TODO: 전체보기 탭 했을 때 리뷰 전체보기 화면으로 네비게이션 기능 구현 필요
                        Text("전체보기")
                            .foregroundStyle(Color.grey6)
                            .font(.suit(.medium, 14))
                        Image(name: Common.rightArrow)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 16, height: 16)
                            .foregroundStyle(Color.grey6)
                    }
                }
            }
        }
    }
    
    private var tabView: some View {
        TabView(selection: $currentpage) {
            ForEach(0..<store.totalPage, id: \.self) { index in
                WithPerceptionTracking {
                    VStack {
                        // 첫 페이지
                        if index == 0 {
                            NavigationLink(
                                state: HomePopularFeature.Path.State.moveToReviewDetailView(.init(id: store.popularReviews[0].id))
                            ) {
                                ReviewCell(review: store.popularReviews[0], type: .medium)
                            }
                            // TODO: 일반 Grid로 변경 필요
                            LazyVGrid(columns: columns) {
                                if store.popularReviews.count-1 >= 1 {
                                    NavigationLink(
                                        state: HomePopularFeature.Path.State.moveToReviewDetailView(.init(id: store.popularReviews[1].id))
                                    ) {
                                        ReviewCell(review: store.popularReviews[1], type: .small)
                                    }
                                }
                                if store.popularReviews.count-1 >= 2 {
                                    NavigationLink(
                                        state: HomePopularFeature.Path.State.moveToReviewDetailView(.init(id: store.popularReviews[2].id))
                                    ) {
                                        ReviewCell(review: store.popularReviews[2], type: .small)
                                    }
                                }
                            }
                        } else {
                            // 이후 페이지
                            LazyVGrid(columns: columns) {
                                ForEach(0..<4) { offset in
                                    WithPerceptionTracking {
                                        let reviewIndex = 3 + (index - 1) * 4 + offset
                                        if store.popularReviews.count-1 >= reviewIndex {
                                            NavigationLink(
                                                state: HomePopularFeature.Path.State.moveToReviewDetailView(.init(id: store.popularReviews[reviewIndex].id))
                                            ) {
                                                ReviewCell(review: store.popularReviews[reviewIndex], type: .small)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .tag(index + 1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
            }
        }
        .frame(height: store.popularReviews.count == 1 ? 270 : 573, alignment: .center)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .animation(.easeInOut, value: currentpage)
    }
    
    private var paging: some View {
        // 탭뷰 페이징
        HStack(spacing: 0) {
            Spacer()
            Image(name: Home.previousPage)
                .padding(.trailing, 12)
                .onTapGesture {
                    if currentpage != 1 {
                        currentpage -= 1
                    }
                }
            Text("\(currentpage)")
                .foregroundStyle(Color.black)
                .font(.suit(.medium, 16))
            Text(" / \(store.state.totalPage)")
                .foregroundStyle(Color.grey8)
                .font(.suit(.medium, 16))
            Image(name: Home.nextPage)
                .padding(.leading, 12)
                .onTapGesture {
                    if currentpage != store.state.totalPage {
                        currentpage += 1
                    }
                }
            Spacer()
        }
    }
}

#Preview("without Reviews") {
    HomePopularView()
}

#Preview("with Reviews") {
    let store: StoreOf<HomePopularFeature> = StoreOf<HomePopularFeature>(
        initialState: HomePopularFeature.State(
            popularReviews: [
                ReviewModel.dummyData,
                ReviewModel.dummyData,
                ReviewModel.dummyData,
                ReviewModel.dummyData,
                ReviewModel.dummyData,
            ]
        )
    ) {
        HomePopularFeature()
    }
    HomePopularView(store: store)
}
