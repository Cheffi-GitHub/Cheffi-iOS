//
//  HomeCheffiStoryView.swift
//  Cheffi
//
//  Created by 정건호 on 6/5/24.
//

import SwiftUI
import ComposableArchitecture

struct HomeCheffiStoryView: View {
    
    @Perception.Bindable var store: StoreOf<HomeCheffiStoryFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                header
                    .padding(.horizontal, 16)
                chipButtons
                    .padding(.bottom, 16)
                tabView
                paging
            }
            .onFirstAppear {
                store.send(.onFirstAppear)
            }
        }
    }
    
    private var header: some View {
        HStack {
            Text("음식, 분위기 맛\n나와 비슷한 쉐피들의 이야기")
                .foregroundStyle(.black)
                .font(.suit(.bold, 20))
                .padding(.bottom, 16)
            Spacer()
        }
    }
    
    private var chipButtons: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(store.categories) { category in
                    Text("\(category.name)")
                        .foregroundStyle(store.selectedCategory == category ? Color.white : Color.grey5)
                        .font(.suit(.semiBold, 15))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(store.selectedCategory == category ? Color.primary : Color.grey1)
                                .background {
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundStyle(store.selectedCategory == category ? Color.primary : Color.white)
                                }
                        )
                        .onTapGesture {
                            store.send(.categoryTapped(category))
                        }
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private var tabView: some View {
        TabView(selection: $store.currentPage) {
            ForEach(1...store.totalPage, id: \.self) { page in
                pageContent(for: page)
                    .tag(page)
            }
        }
        .frame(height: pageHeight)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .animation(.easeInOut, value: store.currentPage)
        .padding(.bottom, 16)
    }

    private func pageContent(for page: Int) -> some View {
        WithPerceptionTracking {
            VStack(spacing: 16) {
                let startIndex = page * store.itemsPerPage
                let endIndex = min(startIndex + store.itemsPerPage, store.recommendList.count)
                
                ForEach(startIndex..<endIndex, id: \.self) { index in
                    WriterRow(
                        photoURL: String(),
                        title: store.recommendList[index].title,
                        intro: store.recommendList[index].intro,
                        isFollowed: store.recommendList[index].isFollowed
                    ) {
                        print("네비게이션 영역 탭")
                    } isFollowedTapped: {
                        print("팔로워 영역 탭")
                        store.recommendList[index].isFollowed.toggle()
                    }
                }
                .padding(.horizontal, 16)
                
                if (endIndex - startIndex) + 1 < store.itemsPerPage {
                    Spacer()
                }
            }
        }
    }

    private var pageHeight: CGFloat {
        CGFloat(store.itemsPerPage * 64 + ((store.itemsPerPage - 1) * 16))
    }
    
    private var paging: some View {
        // 탭뷰 페이징
        HStack(spacing: 0) {
            Image(name: Home.previousPage)
                .padding(.trailing, 12)
                .onTapGesture {
                    store.send(.previeousPageButtonTapped)
                }
            Text("\(store.currentPage)")
                .foregroundStyle(Color.black)
                .font(.suit(.medium, 16))
            Text(" / \(store.totalPage)")
                .foregroundStyle(Color.grey8)
                .font(.suit(.medium, 16))
            Image(name: Home.nextPage)
                .padding(.leading, 12)
                .onTapGesture {
                    store.send(.nextPageButtonTapped)
                }
        }
    }
}

#Preview {
    let store = StoreOf<HomeCheffiStoryFeature>(initialState: HomeCheffiStoryFeature.State()) {
        HomeCheffiStoryFeature()
    }
    HomeCheffiStoryView(store: store)
}

struct RecommendData: Hashable {
    let title: String
    let intro: String
    var isFollowed: Bool
}
