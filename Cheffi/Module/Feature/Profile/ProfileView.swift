//
//  ProfileView.swift
//  Cheffi
//
//  Created by 정건호 on 7/29/24.
//

import SwiftUI
import Kingfisher
import WrappingHStack

struct ProfileView: View {
    
    @State private var tags = ["매콤한", "노포", "웨이팅 짧은", "아시아음식", "한식", "비건", "분위기 있는 곳"]
    @State private var tabs = ["리뷰", "구매한 리뷰", "찜한 리뷰"]
    @State private var selectedTab = 0
    
    var body: some View {
        ScrollView {
            // NavigationBar
            HStack {
                Image(name: Common.leftArrow)
                    .renderingMode(.template)
                    .foregroundStyle(Color.black)
                Spacer()
                Text("동구밭에서 캔 감자")
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
                    Color.grey3
                }
                .frame(width: 100, height: 100)
                .clipShape(.rect(cornerRadius: 60))
                VStack {
                    HStack {
                        VStack(spacing: 2) {
                            Text("12")
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
                            Text("16")
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
                            Text("24")
                                .font(.suit(.semiBold, 18))
                                .foregroundStyle(Color.black)
                            Text("팔로잉")
                                .font(.suit(.regular, 12))
                                .foregroundStyle(Color.grey8)
                        }
                    }
                    .padding(.horizontal, 12)
                    Spacer()
                    Text("팔로우")
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color.white)
                        .background(Color.grey9)
                        .font(.suit(.medium, 15))
                        .clipShape(.rect(cornerRadius: 8))
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
            
            // Introduce, Tags
            VStack {
                Text("동구밭 과수원길에서 태어난 감자입니다")
                    .font(.suit(.regular, 15))
                    .foregroundStyle(Color.grey9)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                WrappingHStack(tags, lineSpacing: 6) { tag in
                    Text(tag)
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
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
            
            // Review Tabview
            Section(content: {
                TabView(selection: $selectedTab) {
                    
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
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
            })
        }
        .padding(.top, 1)
    }
}

#Preview {
    ProfileView()
}
