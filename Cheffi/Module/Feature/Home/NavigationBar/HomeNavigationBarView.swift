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
    
    @Perception.Bindable var store: StoreOf<HomeNavigationBarFeature> = .init(
        initialState: HomeNavigationBarFeature.State()) {
            HomeNavigationBarFeature()
        }
    let type: HomeNavigationType
    
    var body: some View {
        WithPerceptionTracking {
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
                    Image(name: Home.search)
                        .padding(.trailing, 20)
                        .onTapGesture {
                            store.send(.searchTapped)
                        }
                    Image(name: Home.alarm)
                        .padding(.trailing, 10)
                        .onTapGesture {
                            store.send(.alarmTapped)
                        }
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 44)
        }
    }
    
    private func regionButton() -> some View {
        HStack(spacing: 8) {
            Text("서울특별시 성동구")
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
        .layoutPriority(1)
        .onTapGesture {
            store.send(.regionTapped)
        }
    }
}

#Preview("back") {
    return HomeNavigationBarView(type: .back)
}

#Preview("normal") {
    return HomeNavigationBarView(type: .normal)
}
