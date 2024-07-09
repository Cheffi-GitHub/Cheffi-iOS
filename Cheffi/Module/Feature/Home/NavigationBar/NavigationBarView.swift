//
//  NavigationBar.swift
//  Cheffi
//
//  Created by 정건호 on 6/3/24.
//

import SwiftUI
import ComposableArchitecture

struct NavigationBarView: View {
    
    @Perception.Bindable var store: StoreOf<NavigationBarFeature> = .init(
        initialState: NavigationBarFeature.State()) {
            NavigationBarFeature()
        }
    
    var body: some View {
        WithPerceptionTracking {
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
                    store.send(.regionTapped)
                }
                Spacer()
                Image(name: Home.search)
                    .padding(10)
                    .onTapGesture {
                        store.send(.searchTapped)
                    }
                Image(name: Home.alarm)
                    .padding(10)
                    .onTapGesture {
                        store.send(.alarmTapped)
                    }
            }
            .padding(.horizontal, 16)
        }
    }
}

