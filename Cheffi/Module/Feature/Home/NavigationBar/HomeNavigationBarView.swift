//
//  NavigationBar.swift
//  Cheffi
//
//  Created by 정건호 on 6/3/24.
//

import SwiftUI
import ComposableArchitecture

enum HomeNavigationType {
    case normal
    case back
}

// TODO: 위치에 따른 네비게이션 타이틀 변경 및 각 버튼 기능동작
struct HomeNavigationBarView: View {
    
    let store: StoreOf<HomeNavigationBarFeature>
    let type: HomeNavigationType
    
    var body: some View {
        HStack(spacing: 0) {
            if type == .back {
                HStack {
                    Image(name: Common.leftArrow)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                        .padding(.leading, 10)
                    Spacer()
                }
            }
            regionButton()
            Spacer()
            HStack(spacing: 0) {
                Spacer()
                NavigationLink(state: HomeFeature.Path.State.searchRestaurant) {
                    Image(name: Home.search)
                        .padding(.trailing, 20)
                }
                
                NavigationLink(state: HomeFeature.Path.State.notification) {
                    Image(name: Home.alarm)
                        .padding(.trailing, 10)
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 44)
    }
    
    private func regionButton() -> some View {
        NavigationLink(state: HomeFeature.Path.State.selectRegion) {
            HStack(spacing: 8) {
                Text("서울특별시 강남구")
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(.black)
                    .foregroundStyle(.white)
                    .font(.suit(.medium, 16))
                    .clipShape(.rect(cornerRadius: 20))
                if type == .normal {
                    Image(name: Common.rightArrow)
                        .padding(3)
                        .background(.black)
                        .clipShape(.rect(cornerRadius: 16))
                }
            }
        }
        .layoutPriority(1)
    }
}

#Preview {
    let store = StoreOf<HomeNavigationBarFeature>(initialState: HomeNavigationBarFeature.State()) {
        HomeNavigationBarFeature()
    }
    HomeNavigationBarView(store: store, type: .back)
    HomeNavigationBarView(store: store, type: .normal)
}
