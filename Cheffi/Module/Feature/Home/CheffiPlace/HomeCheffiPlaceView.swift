//
//  HomeCheffiPlaceView.swift
//  Cheffi
//
//  Created by 정건호 on 6/10/24.
//

import SwiftUI

struct HomeCheffiPlaceView: View {
    @State private var selectedTab: Int = 0
    @State private var tabViewHeight: CGFloat = 150
    @State private var tabViewHeightTemp: CGFloat = 150
    @State private var height: CGFloat = 500
    
    private let columns = [
        GridItem(.flexible(), alignment: .top),
        GridItem(.flexible(), alignment: .top)
    ]
    
    let tags: [TagType] = [
        TagType(id: 1, name: "한식", type: "FOOD"),
        TagType(id: 2, name: "중식", type: "FOOD"),
        TagType(id: 3, name: "일식", type: "FOOD"),
        TagType(id: 4, name: "양식", type: "FOOD"),
        TagType(id: 5, name: "샐러드", type: "FOOD"),
        TagType(id: 6, name: "해산물/회", type: "FOOD"),
        TagType(id: 7, name: "아시아음식", type: "FOOD"),
        TagType(id: 8, name: "분식", type: "FOOD"),
        TagType(id: 9, name: "면/국수", type: "FOOD"),
        TagType(id: 10, name: "브런치", type: "FOOD"),
        TagType(id: 11, name: "코스요리", type: "FOOD"),
        TagType(id: 12, name: "구이", type: "FOOD"),
        TagType(id: 13, name: "카페", type: "FOOD"),
        TagType(id: 14, name: "한정식", type: "FOOD"),
        TagType(id: 15, name: "다이닝바", type: "FOOD"),
        TagType(id: 16, name: "비건", type: "FOOD"),
        TagType(id: 17, name: "백반", type: "FOOD"),
        TagType(id: 18, name: "가정식", type: "FOOD"),
        TagType(id: 19, name: "뷔페", type: "FOOD")
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
        LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
            Section(content: {
                VStack(spacing: 0) {
                    TabView(selection: $selectedTab) {
                        ForEach(0..<tags.count, id: \.self) { index in
                            if let data = tagDatas.first(where: { $0.0 == tags[index].id }) {
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
                .frame(height: height)
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
                                ForEach(0..<tags.count, id: \.self) { index in
                                    VStack {
                                        Text(tags[index].name)
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
                .onAppear {
                    height = UIWindow().screen.bounds.height - 284
                }
            })
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
