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
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State private var currentpage = 1
    
    var body: some View {
        WithPerceptionTracking {
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("인기 급등 맛집")
                        .foregroundStyle(.black)
                        .font(.suit(.bold, 20))
                        .padding(.bottom, 16)
                        .padding(.leading, 16)
                    if store.popularReviews.count == 0 {
                        VStack(alignment: .center, spacing: 0) {
                            Image(name: Home.homeEmpty)
                                .padding(.bottom, 12)
                            Text("아직 주변의 맛집 리뷰가 없어요\n먼저 주변 아는 맛집을 소개해주세요!")
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
                    } else {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(spacing: 0) {
                                Image(name: Common.clock)
                                Text("00 : 13 : 43")
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
                                    .onTapGesture {
                                        store.send(.toolTipTapped)
                                    }
                                Spacer()
                                NavigationLink(state: HomePopularFeature.Path.State.moveToAllReviewView(
                                    .init(popularReviews: store.popularReviews)
                                )) {
                                    HStack {
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
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                        
                        TabView(selection: $currentpage) {
                            ForEach(0..<store.totalPage, id: \.self) { index in
                                WithPerceptionTracking {
                                    VStack {
                                        if index == 0 {
                                            NavigationLink(
                                                state: HomePopularFeature.Path.State.moveToReviewDetailView(.init(id: store.popularReviews[0].id))
                                            ) {
                                                PlaceCell(review: store.popularReviews[0], type: .medium)
                                            }
                                            LazyVGrid(columns: columns) {
                                                if store.popularReviews.count-1 >= 1 {
                                                    NavigationLink(
                                                        state: HomePopularFeature.Path.State.moveToReviewDetailView(.init(id: store.popularReviews[1].id))
                                                    ) {
                                                        PlaceCell(review: store.popularReviews[1], type: .small)
                                                    }
                                                }
                                                if store.popularReviews.count-1 >= 2 {
                                                    NavigationLink(
                                                        state: HomePopularFeature.Path.State.moveToReviewDetailView(.init(id: store.popularReviews[2].id))
                                                    ) {
                                                        PlaceCell(review: store.popularReviews[2], type: .small)
                                                    }
                                                }
                                            }
                                        } else {
                                            LazyVGrid(columns: columns) {
                                                ForEach(0..<4) { offset in
                                                    let reviewIndex = 3 + (index - 1) * 4 + offset
                                                    if store.popularReviews.count-1 >= reviewIndex {
                                                        NavigationLink(
                                                            state: HomePopularFeature.Path.State.moveToReviewDetailView(.init(id: store.popularReviews[reviewIndex].id))
                                                        ) {
                                                            PlaceCell(review: store.popularReviews[reviewIndex], type: .small)
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
                .onAppear {
                    store.send(.requestPopularReviews)
                }
            } destination: { store in
                switch store.state {
                case .moveToReviewDetailView:
                    if let store = store.scope(state: \.moveToReviewDetailView, action: \.moveToReviewDetailView) {
                        ReviewDetailView(store: store)
                    }
                case .moveToAllReviewView:
                    if let store = store.scope(state: \.moveToAllReviewView, action: \.moveToAllReviewView) {
                        AllReviewView(store: store)
                    }
                }
            }
        }
    }
}
