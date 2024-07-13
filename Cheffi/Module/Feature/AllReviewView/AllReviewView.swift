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
    
    private let columns = [
        GridItem(.flexible(), alignment: .top),
        GridItem(.flexible(), alignment: .top)
    ]
    
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
                            Text(store.remainTime.toHourMinuteSecond())
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
                    .padding(.horizontal, 16)
                    .padding(.top, 32)
                    
                    Group {
                        if let popularReviews = store.popularReviews {
                            if store.viewType == .expand {
                                LazyVStack {
                                    ForEach(0..<popularReviews.count, id: \.self) { index in
                                        WithPerceptionTracking {
                                            ReviewCell(
                                                review: popularReviews[index],
                                                type: .large
                                            )
                                            .onAppear {
                                                if popularReviews.count - 3 == index, store.hasNext {
                                                    store.send(.requestPopularReviews)
                                                }
                                            }
                                        }
                                    }
                                }
                            } else {
                                LazyVGrid(columns: columns) {
                                    ForEach(0..<popularReviews.count, id: \.self) { index in
                                        WithPerceptionTracking {
                                            ReviewCell(
                                                review: popularReviews[index],
                                                type: .small
                                            )
                                            .onAppear {
                                                if popularReviews.count - 3 == index, store.hasNext {
                                                    store.send(.requestPopularReviews)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top, 24)
                    .padding(.horizontal, 16)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                store.send(.startTimer)
            }
        }
    }
}

#Preview {
    AllReviewView(store: .init(
        initialState: AllReviewFeature.State(remainTime: 3600)) {
            AllReviewFeature()
        })
}
