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


/*
 TODO: Empty View의 높이 설정하기, 스와이프로 탭 바꿀 경우에 자연스럽게 바뀌도록 수정하기
 */

struct ProfileView: View {
    
    @Perception.Bindable var store: StoreOf<ProfileFeature> = .init(
        initialState: ProfileFeature.State()) {
            ProfileFeature()
        }
    
    @State private var tags = ["매콤한", "노포", "웨이팅 짧은", "아시아음식", "한식", "비건", "분위기 있는 곳"]
    @State private var tabs = ["리뷰", "구매한 리뷰", "찜한 리뷰"]
    @State private var selectedTab = 0
    
    private let columns = [
        GridItem(.flexible(), alignment: .top),
        GridItem(.flexible(), alignment: .top)
    ]
    
    var body: some View {
        WithPerceptionTracking {
            if let profile = store.profile, let _ = store.reviews {
                ScrollView {
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
                                Text("팔로잉")
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                                    .foregroundStyle(Color.grey9)
                                    .background(Color.clear)
                                    .font(.suit(.medium, 15))
                                    .clipShape(.rect(cornerRadius: 8))
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .strokeBorder(Color.grey2)
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
                    Section(content: {
                        ZStack {
                            Group {
                                WithPerceptionTracking {
                                    if selectedTab == 0 {
                                        Group {
                                            if let reviews = store.reviews, reviews.count != 0 {
                                                LazyVGrid(columns: columns, spacing: 24) {
                                                    ForEach(0..<reviews.count, id: \.self) { index in
                                                        ReviewCell(review: reviews[index], type: .small)
                                                            .onAppear {
                                                                if let _ = store.reviewsHasNext, reviews.count-3 == index {
                                                                    store.send(.requestReviews)
                                                                }
                                                            }
                                                    }
                                                }
                                                .padding(.horizontal, 16)
                                            } else {
                                                VStack(spacing: 14) {
                                                    Spacer()
                                                    Image(name: Profile.reviewsEmpty)
                                                    Text("작성한 리뷰가 없어요")
                                                        .font(.suit(.regular, 16))
                                                        .foregroundStyle(Color.grey6)
                                                    Spacer()
                                                }
                                                .frame(height: 400)
                                            }
                                        }
                                    } else if selectedTab == 1 {
                                        Group {
                                            if let purchase = store.purchase, purchase.count != 0 {
                                                LazyVGrid(columns: columns, spacing: 24) {
                                                    ForEach(0..<purchase.count, id: \.self) { index in
                                                        ReviewCell(review: purchase[index], type: .small)
                                                            .onAppear {
                                                                if let _ = store.purchaseHasNext, purchase.count-3 == index {
                                                                    store.send(.requestPurchase)
                                                                }
                                                            }
                                                    }
                                                }
                                                .padding(.horizontal, 16)
                                            } else {
                                                VStack(spacing: 14) {
                                                    Spacer()
                                                    Image(name: Profile.purchaseEmpty)
                                                    Text("구매한 리뷰가 없어요")
                                                        .font(.suit(.regular, 16))
                                                        .foregroundStyle(Color.grey6)
                                                    Spacer()
                                                }
                                                .frame(height: 400)
                                            }
                                        }
                                        
                                    } else if selectedTab == 2 {
                                        Group {
                                            if let bookmarks = store.bookmarks, bookmarks.count != 0 {
                                                LazyVGrid(columns: columns, spacing: 24) {
                                                    ForEach(0..<bookmarks.count, id: \.self) { index in
                                                        ReviewCell(review: bookmarks[index], type: .small)
                                                            .onAppear {
                                                                if let _ = store.bookmarksHasNext, bookmarks.count-3 == index {
                                                                    store.send(.requestBookmarks)
                                                                }
                                                            }
                                                    }
                                                }
                                                .padding(.horizontal, 16)
                                            } else {
                                                VStack(spacing: 14) {
                                                    Spacer()
                                                    Image(name: Profile.bookmarksEmpty)
                                                    Text("찜한 리뷰가 없어요")
                                                        .font(.suit(.regular, 16))
                                                        .foregroundStyle(Color.grey6)
                                                    Spacer()
                                                }
                                                .frame(height: 400)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .hidden(true)
                            TabView(selection: $selectedTab) {
                                ForEach(0..<tabs.count, id: \.self) { index in
                                    WithPerceptionTracking {
                                        if index == 0 {
                                            Group {
                                                if let reviews = store.reviews, reviews.count != 0 {
                                                    LazyVGrid(columns: columns, spacing: 24) {
                                                        ForEach(0..<reviews.count, id: \.self) { index in
                                                            ReviewCell(review: reviews[index], type: .small)
                                                        }
                                                    }
                                                    .padding(.horizontal, 16)
                                                } else {
                                                    VStack(spacing: 14) {
                                                        Spacer()
                                                        Image(name: Profile.reviewsEmpty)
                                                        Text("작성한 리뷰가 없어요")
                                                            .font(.suit(.regular, 16))
                                                            .foregroundStyle(Color.grey6)
                                                        Spacer()
                                                    }
                                                    .frame(height: 400)
                                                }
                                            }
                                            .tag(index)
                                        } else if index == 1 {
                                            Group {
                                                if let purchase = store.purchase, purchase.count != 0 {
                                                    LazyVGrid(columns: columns, spacing: 24) {
                                                        ForEach(0..<purchase.count, id: \.self) { index in
                                                            ReviewCell(review: purchase[index], type: .small)
                                                        }
                                                    }
                                                    .padding(.horizontal, 16)
                                                } else {
                                                    VStack(spacing: 14) {
                                                        Spacer()
                                                        Image(name: Profile.purchaseEmpty)
                                                        Text("구매한 리뷰가 없어요")
                                                            .font(.suit(.regular, 16))
                                                            .foregroundStyle(Color.grey6)
                                                        Spacer()
                                                    }
                                                    .frame(height: 400)
                                                }
                                            }
                                            .tag(index)
                                            .onFirstAppear {
                                                store.send(.requestPurchase)
                                            }
                                        } else if index == 2 {
                                            Group {
                                                if let bookmarks = store.bookmarks, bookmarks.count != 0 {
                                                    LazyVGrid(columns: columns, spacing: 24) {
                                                        ForEach(0..<bookmarks.count, id: \.self) { index in
                                                            ReviewCell(review: bookmarks[index], type: .small)
                                                        }
                                                    }
                                                    .padding(.horizontal, 16)
                                                } else {
                                                    VStack(spacing: 14) {
                                                        Spacer()
                                                        Image(name: Profile.bookmarksEmpty)
                                                        Text("찜한 리뷰가 없어요")
                                                            .font(.suit(.regular, 16))
                                                            .foregroundStyle(Color.grey6)
                                                        Spacer()
                                                    }
                                                    .frame(height: 400)
                                                }
                                            }
                                            .onFirstAppear {
                                                store.send(.requestBookmarks)
                                            }
                                        }
                                    }
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        }
                    }, header: {
                        HStack(spacing: 0) {
                            ForEach(0..<tabs.count, id: \.self) { index in
                                VStack {
                                    Text(tabs[index])
                                        .foregroundStyle(selectedTab == index ? Color.grey9 : Color.grey5)
                                        .font(.suit(.bold, 15))
                                        .frame(maxWidth: .infinity)
                                        .padding(EdgeInsets(top: 10, leading: 16, bottom: 8, trailing: 16))
                                        .onTapGesture {
                                            selectedTab = index
                                        }
                                    ZStack {
                                        Color.grey05.frame(height: 2)
                                        Rectangle()
                                            .frame(height: 2)
                                            .foregroundStyle(selectedTab == index ? Color.grey9 : Color.clear)
                                            .padding(.horizontal, 16)
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 16)
                    })
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
