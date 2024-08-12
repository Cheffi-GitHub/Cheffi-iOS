//
//  ProfileView.swift
//  Cheffi
//
//  Created by 정건호 on 7/29/24.
//

import SwiftUI
import Kingfisher
import WrappingHStack
import ComposableArchitecture
import PagerTabStripView

/*
 TODO: Empty View의 높이 설정하기, 페이징 처리
 */

struct ProfileView: View {
    
    @Perception.Bindable var store: StoreOf<ProfileFeature> = .init(
        initialState: ProfileFeature.State()) {
            ProfileFeature()
        }
    
    @State private var selectedTab = 0
    
    var body: some View {
        WithPerceptionTracking {
            if let profile = store.profile, let _ = store.reviews {
                PlainList {
                    // NavigationBar
                    HStack {
                        Image(name: Common.leftArrow)
                            .renderingMode(.template)
                            .foregroundStyle(Color.black)
                        Spacer()
                        Text(profile.nickname)
                            .font(.suit(.semiBold, 16))
                            .foregroundStyle(Color.black)
                        Spacer()
                        Image(name: Common.dots)
                            .renderingMode(.template)
                            .foregroundStyle(Color.grey6)
                    }
                    .frame(height: 44)
                    .padding(.horizontal, 26)
                    .padding(.bottom, 24)
                    
                    // Profile Image, Follow Info
                    HStack(spacing: 24) {
                        Group {
                            if let photoUrl = profile.photo.url,
                               let url = URL(string: photoUrl) {
                                KFImage(url)
                                    .resizable()
                            } else {
                                Color.grey3
                            }
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(.rect(cornerRadius: 60))
                        VStack {
                            HStack {
                                VStack(spacing: 2) {
                                    Text("\(profile.post)")
                                        .font(.suit(.semiBold, 18))
                                        .foregroundStyle(Color.black)
                                    Text("리뷰")
                                        .font(.suit(.regular, 12))
                                        .foregroundStyle(Color.grey8)
                                }
                                Spacer()
                                Text("|")
                                    .foregroundStyle(Color.grey2)
                                Spacer()
                                VStack(spacing: 2) {
                                    Text("\(profile.followerCount)")
                                        .font(.suit(.semiBold, 18))
                                        .foregroundStyle(Color.black)
                                    Text("팔로워")
                                        .font(.suit(.regular, 12))
                                        .foregroundStyle(Color.grey8)
                                }
                                Spacer()
                                Text("|")
                                    .foregroundStyle(Color.grey2)
                                Spacer()
                                VStack(spacing: 2) {
                                    Text("\(profile.followingCount)")
                                        .font(.suit(.semiBold, 18))
                                        .foregroundStyle(Color.black)
                                    Text("팔로잉")
                                        .font(.suit(.regular, 12))
                                        .foregroundStyle(Color.grey8)
                                }
                            }
                            .padding(.horizontal, 12)
                            Spacer()
                            if let following = profile.following {
                                Text(following ? "팔로잉" : "팔로우")
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                                    .foregroundStyle(following ? Color.grey9 : Color.white)
                                    .background(following ? Color.clear : Color.grey9)
                                    .font(.suit(.medium, 15))
                                    .clipShape(.rect(cornerRadius: 8))
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .strokeBorder(following ? Color.grey2 : Color.clear)
                                    )
                            } else {
                                Text("팔로우")
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                                    .foregroundStyle(Color.white)
                                    .background(Color.grey9)
                                    .font(.suit(.medium, 15))
                                    .clipShape(.rect(cornerRadius: 8))
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .strokeBorder(Color.clear)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                    
                    // Introduce, Tags
                    VStack {
                        Text(profile.introduction ?? String())
                            .font(.suit(.regular, 15))
                            .foregroundStyle(Color.grey9)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if let tags = profile.tags {
                            WrappingHStack(tags, lineSpacing: 6) { tag in
                                Text(tag.name)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 12)
                                    .foregroundStyle(Color.grey7)
                                    .font(.suit(.medium, 15))
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color.grey1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                    
                    // Review Tabview
                    ZStack {
                        Group {
                            if selectedTab == 0 {
                                ProfileReviewList(
                                    type: .review,
                                    reviews: store.reviews,
                                    hasNext: store.reviewsHasNext,
                                    pagingAction: {
                                        store.send(.requestReviews)
                                    }
                                )
                            } else if selectedTab == 1 {
                                ProfileReviewList(
                                    type: .purchase,
                                    reviews: store.purchase,
                                    hasNext: store.purchaseHasNext,
                                    pagingAction: {
                                        store.send(.requestPurchase)
                                    }
                                )
                            } else if selectedTab == 2 {
                                ProfileReviewList(
                                    type: .bookmark,
                                    reviews: store.bookmarks,
                                    hasNext: store.bookmarksHasNext,
                                    pagingAction: {
                                        store.send(.requestBookmarks)
                                    }
                                )
                            }
                            Spacer().frame(height: 100)
                        }
                        .hidden(true)
                        PagerTabStripView(selection: $selectedTab) {
                            WithPerceptionTracking {
                                ProfileReviewList(
                                    type: .review,
                                    reviews: store.reviews,
                                    hasNext: store.reviewsHasNext,
                                    pagingAction: {
                                        store.send(.requestReviews)
                                    }
                                )
                                .pagerTabItem(tag: 0) {
                                    Text("리뷰")
                                        .foregroundStyle(selectedTab == 0 ? Color.grey9 : Color.grey5)
                                        .font(.suit(.bold, 15))
                                        .overlay(
                                            Color.grey05.frame(width: UIScreen.main.bounds.width/3, height: 2).offset(y: 11),
                                            alignment: .bottom
                                        )
                                }
                                ProfileReviewList(
                                    type: .purchase,
                                    reviews: store.purchase,
                                    hasNext: store.purchaseHasNext,
                                    pagingAction: {
                                        store.send(.requestPurchase)
                                    }
                                )
                                .pagerTabItem(tag: 1) {
                                    Text("구매한 리뷰")
                                        .foregroundStyle(selectedTab == 1 ? Color.grey9 : Color.grey5)
                                        .font(.suit(.bold, 15))
                                        .overlay(
                                            Color.grey05.frame(width: UIScreen.main.bounds.width/3, height: 2).offset(y: 11),
                                            alignment: .bottom
                                        )
                                }
                                ProfileReviewList(
                                    type: .bookmark,
                                    reviews: store.bookmarks,
                                    hasNext: store.bookmarksHasNext,
                                    pagingAction: {
                                        store.send(.requestBookmarks)
                                    }
                                )
                                .pagerTabItem(tag: 2) {
                                    Text("찜한 리뷰")
                                        .foregroundStyle(selectedTab == 2 ? Color.grey9 : Color.grey5)
                                        .font(.suit(.bold, 15))
                                        .overlay(
                                            Color.grey05.frame(width: UIScreen.main.bounds.width/3, height: 2).offset(y: 11),
                                            alignment: .bottom
                                        )
                                }
                            }
                        }
                        .scrollDisabled(true)
                        .pagerTabStripViewStyle(
                            .barButton(
                                tabItemSpacing: 15,
                                tabItemHeight: 40,
                                indicatorView: {
                                    Rectangle().fill(Color.grey9).cornerRadius(5)
                                }
                            ))
                    }
                }
                .padding(.top, 1)
            } else {
                ProgressView()
            }
        }
        .onFirstAppear {
            store.send(.onFirstAppear)
        }
    }
}

#Preview {
    ProfileView()
}
