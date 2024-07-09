//
//  NavigationBar.swift
//  Cheffi
//
//  Created by 정건호 on 6/3/24.
//

import SwiftUI
import ComposableArchitecture

struct NavigationBarView: View {
    
    let store: StoreOf<NavigationBarFeature> = .init(
        initialState: NavigationBarFeature.State()) {
            NavigationBarFeature()
        }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack(spacing: 0) {
                HStack(spacing: 8) {
                    Text("서울특별시 성동구")
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(.black)
                        .foregroundStyle(.white)
                        .font(.suit(.medium, 16))
                        .clipShape(.rect(cornerRadius: 20))
                    Image(name: Common.rightArrow)
                        .padding(3)
                        .background(.black)
                        .clipShape(.rect(cornerRadius: 16))
                }
                .onTapGesture {
                    viewStore.send(.regionTapped)
                }
                Spacer()
                Image(name: Home.search)
                    .padding(10)
                    .onTapGesture {
                        viewStore.send(.searchTapped)
                    }
                Image(name: Home.alarm)
                    .padding(10)
                    .onTapGesture {
                        viewStore.send(.alarmTapped)
                    }
            }
            .padding(.horizontal, 16)
        }
    }
}

