//
//  HomeCheffiStoryView.swift
//  Cheffi
//
//  Created by 정건호 on 6/5/24.
//

import SwiftUI
import ComposableArchitecture

struct HomeCheffiStoryView: View {
    
    private let store: StoreOf<HomeCheffiStoryFeature> = .init(
        initialState: HomeCheffiStoryFeature.State()) {
            HomeCheffiStoryFeature()
        }
    
    @State private var dummyCategories = ["한식", "노포", "아시아음식", "매운맛", "일식", "달콤한맛", "중식"]
    
    @State private var dummyDatas = [
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
    
    @State private var currentpage = 1
    private let itemsPerPage = 3
    private var totalPage: Int {
        (dummyDatas.count + itemsPerPage - 1) / itemsPerPage
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    Text("음식, 분위기 맛\n나와 비슷한 쉐피들의 이야기")
                        .foregroundStyle(.black)
                        .font(.suit(.bold, 20))
                        .padding(.bottom, 16)
                    Spacer()
                }
                .padding(.horizontal, 16)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach($dummyCategories, id: \.self) { category in
                            Group {
                                if !viewStore.state.selectedCategories.contains(category.wrappedValue) {
                                    Text("\(category.wrappedValue)")
                                        .foregroundStyle(Color.grey5)
                                        .font(.suit(.semiBold, 15))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 6)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .strokeBorder(Color.grey1)
                                        )
                                    
                                } else {
                                    Text("\(category.wrappedValue)")
                                        .foregroundStyle(Color.white)
                                        .font(.suit(.semiBold, 15))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 6)
                                        .background(Color.primary)
                                        .clipShape(.rect(cornerRadius: 20))
                                }
                            }
                            .onTapGesture {
                                viewStore.send(.categoryTapped(category.wrappedValue))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 16)
                
                TabView(selection: $currentpage) {
                    ForEach(1...totalPage, id: \.self) { index in
                        VStack(spacing: 16) {
                            let startIndex = (index - 1) * itemsPerPage
                            let endIndex = min(startIndex + itemsPerPage, dummyDatas.count)
                            let items = Array(dummyDatas[startIndex..<endIndex])
                            ForEach(items, id: \.title) { item in
                                HStack {
                                    Image(name: Dummy.sample)
                                        .resizable()
                                        .frame(width: 64, height: 64)
                                        .clipShape(.rect(cornerRadius: 8))
                                    Spacer().frame(width: 12)
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(item.title)
                                            .foregroundStyle(Color.black)
                                            .font(.suit(.semiBold, 16))
                                            .lineLimit(1)
                                        Text(item.intro)
                                            .foregroundStyle(Color.grey5)
                                            .font(.suit(.regular, 12))
                                            .lineLimit(2)
                                    }
                                    Spacer().frame(minWidth: 32)
                                    
                                    Group {
                                        if item.isFollowed {
                                            Text("팔로우")
                                                .padding(.vertical, 6)
                                                .padding(.horizontal, 20)
                                                .background(Color.black)
                                                .foregroundStyle(Color.white)
                                                .font(.suit(.bold, 12))
                                                .clipShape(.rect(cornerRadius: 8))
                                        } else {
                                            Text("팔로잉")
                                                .padding(.vertical, 6)
                                                .padding(.horizontal, 20)
                                                .foregroundStyle(Color.black)
                                                .font(.suit(.bold, 12))
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .strokeBorder(Color.grey2)
                                                )
                                        }
                                    }
                                }
                                .frame(height: 64)
                            }
                            .padding(.horizontal, 16)
                            if items.count != 3 {
                                Spacer()
                            }
                        }
                    }
                }
                .frame(height: CGFloat(itemsPerPage * 64 + ((itemsPerPage - 1) * 16)))
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentpage)
                .padding(.bottom, 16)
                
                // 탭뷰 페이징
                HStack(spacing: 0) {
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
                    Text(" / \(totalPage)")
                        .foregroundStyle(Color.grey8)
                        .font(.suit(.medium, 16))
                    Image(name: Home.nextPage)
                        .padding(.leading, 12)
                        .onTapGesture {
                            if currentpage != totalPage {
                                currentpage += 1
                            }
                        }
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

#Preview {
    HomeCheffiStoryView()
}

struct RecommendData: Hashable {
    let title: String
    let intro: String
    let isFollowed: Bool
}
