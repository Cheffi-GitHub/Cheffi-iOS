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
    
    @State private var tagDatas: [(Int, [Int])] = [
        (1, [1]),
        (2, [1,2]),
        (3, [1,2,3]),
        (4, [1,2,3,4]),
        (5, [1,2,3,4,5]),
        (6, [1,2,3,4,5,6]),
        (7, [1,2,3,4,5,6,7]),
        (8, [1,2,3,4,5,6,7,8]),
        (9, [1,2,3,4,5,6,7,8,9]),
        (10, [1,2,3,4,5,6,7,8,9,10])
        //        (1, [1,2,3]),
        //        (1, [1,2,3]),
        //        (1, [1,2,3]),
        //        (1, [1,2,3]),
        //        (1, [1,2,3]),
        //        (1, [1,2,3]),
        //        (1, [1,2,3]),
        //        (1, [1,2,3]),
        
    ]
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                Section(content: {
                    VStack(spacing: 0) {
                        TabView(selection: $selectedTab) {
                            ForEach(0..<viewStore.state.tags.count, id: \.self) { index in
                                if let data = tagDatas.first(where: { $0.0 == viewStore.state.tags[index].id }) {
                                    ScrollView(showsIndicators: false) {
                                        LazyVGrid(columns: columns, spacing: 24) {
                                            ForEach(data.1, id: \.self) { item in
                                                PlaceCell(type: .small)
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                        .tag(index)
                                    }
                                } else {
                                    Text("Empty View")
                                        .tag(index)
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
