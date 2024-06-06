//
//  HomePopularView.swift
//  Cheffi
//
//  Created by 정건호 on 6/3/24.
//

import SwiftUI
import ComposableArchitecture

struct HomePopularView: View {
    
    private let store: StoreOf<HomePopularFeature> = .init(
        initialState: HomePopularFeature.State()) {
            HomePopularFeature()
        }
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State private var currentpage = 1
    private let totalPage = 4
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("인기 급등 맛집")
                        .foregroundStyle(.black)
                        .font(.suit(.bold, 20))
                        .padding(.bottom, 16)
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
                                viewStore.send(.toolTipTapped)
                            }
                        Spacer()
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
                        .onTapGesture {
                            viewStore.send(.viewAllTapped)
                        }
                    }
                }
                .padding(.horizontal, 16)
                
                TabView(selection: $currentpage) {
                    ForEach(1...totalPage, id: \.self) { index in
                        if index == 1 {
                            VStack {
                                PlaceCell(type: .medium)
                                LazyVGrid(columns: columns) {
                                    PlaceCell(type: .small)
                                    PlaceCell(type: .small)
                                }
                            }
                            .padding(.horizontal, 16)
                            .tag(index)
                        } else {
                            LazyVGrid(columns: columns) {
                                PlaceCell(type: .small)
                                PlaceCell(type: .small)
                                PlaceCell(type: .small)
                                PlaceCell(type: .small)
                            }
                            .padding(.horizontal, 16)
                            .tag(index)
                        }
                    }
                }
                .frame(height: 600)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentpage)
                
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
        }
    }
}
