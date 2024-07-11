//
//  AllReviewView.swift
//  Cheffi
//
//  Created by 정건호 on 7/9/24.
//

import SwiftUI
import ComposableArchitecture

enum ReviewViewType {
    case expand
    case collapse
}

struct AllReviewView: View {
    
    @Perception.Bindable var store: StoreOf<AllReviewFeature>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                NavigationBarView(type: .back)
                    .onTapGesture {
                        dismiss()
                    }
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
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
                            Spacer()
                            HStack(spacing: 20) {
                                Image(name: store.viewType == .expand ? Home.selectedExpand : Home.normalExpand)
                                    .onTapGesture {
                                        store.send(.changeViewType(type: .expand))
                                    }
                                Image(name: store.viewType == .collapse ? Home.selectedCollapse : Home.normalCollapse)
                                    .onTapGesture {
                                        store.send(.changeViewType(type: .collapse))
                                    }
                            }
                        }
                        
                    }
                    
                    
                    // Cell
                    PlaceCell(type: .large)
                        .padding(.top, 24)
                }
                .padding(.top, 32)
                .padding(.horizontal, 16)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}


#Preview {
    AllReviewView(store: .init(
        initialState: AllReviewFeature.State()) {
            AllReviewFeature()
        })
}
