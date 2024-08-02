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
            GeometryReader { geometry in
                if let profile = store.profile {
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
                        .padding(.horizontal, 16)
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
                                LazyVGrid(columns: columns, spacing: 24) {
                                    ForEach(0...10, id: \.self) { _ in
                                        ReviewCell(type: .small)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .hidden(true)
                                TabView(selection: $selectedTab) {
                                    ForEach(0..<tabs.count, id: \.self) { index in
                                        LazyVGrid(columns: columns, spacing: 24) {
                                            ForEach(0...10, id: \.self) { _ in
                                                ReviewCell(type: .small)
                                            }
                                        }
                                        .padding(.horizontal, 16)
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
                                    .onChange(of: selectedTab) { index in
                                        selectedTab = index
                                    }
                                }
                            }
                            .padding(.bottom, 16)
                        })
                    }
                    .padding(.top, 1)
                } else {
                    ProgressView()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .toolbar(.hidden, for: .navigationBar)
                }
            }
            .onAppear {
                store.send(.requestProfile)
            }
        }
    }
}

#Preview {
    ProfileView()
}
