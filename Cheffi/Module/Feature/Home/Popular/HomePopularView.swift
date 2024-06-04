//
//  HomePopularView.swift
//  Cheffi
//
//  Created by 정건호 on 6/3/24.
//

import SwiftUI
import ComposableArchitecture

struct HomePopularView: View {
    
    let store: StoreOf<HomePopularFeature> = .init(
        initialState: HomePopularFeature.State()) {
            HomePopularFeature()
        }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("인기 급등 맛집")
                        .foregroundStyle(.black)
                        .font(.suit(.bold, 20))
                        .padding(.bottom, 16)
                    HStack(spacing: 0) {
                        Image(name: .clock)
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
                        Image(name: .info)
                            .onTapGesture {
                                viewStore.send(.toolTipTapped)
                            }
                        Spacer()
                        HStack {
                            Text("전체보기")
                                .foregroundStyle(Color.grey6)
                                .font(.suit(.medium, 14))
                            Image(name: .rightArrow)
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
                Spacer().frame(height: 24)
                PlaceCell()
            }
            .padding(.horizontal, 16)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    NavigationBarView()
                }
            }
        }
    }
}

