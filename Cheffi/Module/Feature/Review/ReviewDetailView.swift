//
//  ReviewDetailView.swift
//  Cheffi
//
//  Created by 정건호 on 6/18/24.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

// TODO: 좋아요, 복사, 식당 평가, 팔로우 기능 구현

struct ReviewDetailView: View {
    
    @Perception.Bindable var store: StoreOf<ReviewDetailFeature>
    @Environment(\.dismiss) private var dismiss
    
    private let screenWidth = UIWindow().screen.bounds.width
    
    @State private var selection = 0
    private let imageCount = 5
    
    @State private var scrollOffset: CGFloat = 0
    @State private var scale: CGFloat = 1
    @State private var navigationBarOpacity: CGFloat = 0
    
    private var navigationForegroundColor: Color {
        Color(white: Double(1 - navigationBarOpacity))
    }
    
    private var navigationBackgroundColor: Color {
        Color.black.opacity(0.5 * Double(1 - navigationBarOpacity))
    }
    
    var body: some View {
        WithPerceptionTracking {
            Group {
                if let review = store.state.reviewDetail {
                    ZStack(alignment: .top) {
                        HStack {
                            Image(name: Common.leftArrow)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(navigationForegroundColor)
                                .frame(width: 24, height: 24)
                                .padding(8)
                                .background(navigationBackgroundColor)
                                .clipShape(.rect(cornerRadius: 20))
                                .onTapGesture {
                                    dismiss()
                                }
                            Spacer()
                            Image(name: Review.dots)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(navigationForegroundColor)
                                .frame(width: 24, height: 24)
                                .padding(8)
                                .background(navigationBackgroundColor)
                                .clipShape(.rect(cornerRadius: 20))
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 10)
                        .background(.white.opacity(navigationBarOpacity))
                        .zIndex(1)
                        
                        ScrollViewOffset(onOffsetChange: { offset in
                            scrollOffset = offset
                            scale = max(0, scrollOffset / screenWidth) + 1
                        }) {
                            ZStack {
                                TabView(selection: $selection) {
                                    ForEach(0..<review.photos.count, id: \.self) { index in
                                        Group {
                                            if let photoUrl = review.photos[index].photo.url,
                                               let url = URL(string: photoUrl) {
                                                KFImage(url)
                                                    .resizable()
                                            } else {
                                                // TODO: 이미지 불러오지 못했을 때 UI 요청
                                                Color.g30
                                            }
                                        }
                                        .scaledToFill()
                                        .frame(width: screenWidth * scale, height: screenWidth * scale)
                                        .clipped()
                                    }
                                }
                                .tabViewStyle(.page(indexDisplayMode: .never))
                                VStack(alignment: .leading, spacing: 0) {
                                    Spacer()
                                    Text("취향 \(review.matchedTagNum ?? 0)개 일치")
                                        .font(.suit(.bold, 14))
                                        .foregroundStyle(.white)
                                        .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                                        .background(.black.opacity(0.32))
                                        .clipShape(.rect(cornerRadius: 20))
                                        .padding(.bottom, 5)
                                    Text(review.title)
                                        .font(.suit(.bold, 24))
                                        .foregroundStyle(.white)
                                        .lineLimit(2)
                                        .padding(.vertical, 5)
                                        .padding(.bottom, 3)
                                        .background(
                                            GeometryReader { geometry -> Color in
                                                let maxY = geometry.frame(in: .global).midY
                                                DispatchQueue.main.async {
                                                    navigationBarOpacity = max(0, (-maxY + 40) / 100)
                                                }
                                                return Color.clear
                                            }
                                        )
                                    HStack {
                                        Text(review.createdDate.timeAgo())
                                            .font(.suit(.medium, 14))
                                            .foregroundStyle(.g30)
                                        Spacer()
                                        HStack(spacing: 0) {
                                            Text("\(selection + 1)")
                                                .font(.suit(.medium, 14))
                                                .foregroundStyle(.white)
                                            Text("/\(review.photos.count)")
                                                .font(.suit(.medium, 14))
                                                .foregroundStyle(.g10)
                                        }
                                        .padding(EdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 10))
                                        .background(.black.opacity(0.32))
                                        .clipShape(.rect(cornerRadius: 20))
                                    }
                                    .padding(.bottom, 16)
                                }
                                .padding(.horizontal, 16)
                            }
                            .overlay(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0.4)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: screenWidth, height: screenWidth + (scrollOffset > 0 ? scrollOffset : 0))
                            .offset(y: (scrollOffset > 0 ? -scrollOffset : 0))
                            
                            Spacer().frame(height: 32)
                            
                            VStack(spacing: 0) {
                                // 식당 이름
                                HStack(alignment: .center) {
                                    Text(review.restaurant.name)
                                        .font(.suit(.bold, 24))
                                        .foregroundStyle(.black)
                                    Spacer()
                                    Image(name: Common.emptyHeart)
                                }
                                .padding(.bottom, 32)
                                // 리뷰 본문
                                Text(review.text)
                                    .font(.suit(.regular, 16))
                                    .foregroundStyle(.g80)
                                    .padding(.bottom, 32)
                                // 메뉴
                                if review.menus.count != 0 {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("메뉴")
                                            .font(.suit(.bold, 18))
                                            .foregroundStyle(.black)
                                            .padding(.bottom, 8)
                                        ForEach(0..<review.menus.count, id: \.self) { index in
                                            HStack {
                                                Text(review.menus[index].name)
                                                    .font(.suit(.regular, 16))
                                                    .foregroundStyle(.g80)
                                                    .frame(width: (screenWidth - 32) * 0.58, alignment: .leading)
                                                    .lineLimit(1)
                                                Spacer()
                                                Text("\(review.menus[index].price)원")
                                                    .font(.suit(.medium, 16))
                                                    .foregroundStyle(.g70)
                                                    .frame(width: (screenWidth - 32) * 0.36, alignment: .trailing)
                                                    .lineLimit(1)
                                            }
                                        }
                                    }
                                    .padding(.bottom, 32)
                                }
                                // 위치
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("위치")
                                        .font(.suit(.bold, 18))
                                        .foregroundStyle(.black)
                                        .padding(.bottom, 6)
                                    HStack {
                                        Text(review.restaurant.address.fullRoadNameAddress)
                                            .font(.suit(.regular, 16))
                                            .foregroundStyle(.g80)
                                            .frame(width: (screenWidth - 32) * 0.88, alignment: .leading)
                                            .lineLimit(1)
                                        Spacer()
                                        Text("복사")
                                            .underline()
                                            .font(.suit(.regular, 14))
                                            .foregroundStyle(Color(hex: 0x34AFF7))
                                            .onTapGesture {
                                                UIPasteboard.general.string = review.restaurant.address.fullRoadNameAddress
                                                store.send(.toggleShowToast(true))
                                            }
                                    }
                                }
                                .padding(.bottom, 32)
                                // 경계선
                                Color.g10.frame(height: 1)
                                    .padding(.bottom, 32)
                                // 작성자
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("작성자")
                                        .font(.suit(.bold, 18))
                                        .foregroundStyle(.black)
                                        .padding(.bottom, 6)
                                    WriterRow(
                                        photoUrl: review.writer.photo.url,
                                        title: review.writer.nickname,
                                        intro: review.writer.introduction,
                                        isFollowed: true
                                    )
                                }
                                .padding(.bottom, 32)
                                // 평가
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("이 식당 어떠셨나요?")
                                        .font(.suit(.bold, 18))
                                        .foregroundStyle(.black)
                                        .padding(.bottom, 12)
                                    HStack {
                                        Spacer()
                                        VStack(spacing: 8) {
                                            Image(name: Review.normalGood)
                                            Text("맛있어요")
                                                .font(.suit(.regular, 12))
                                                .foregroundStyle(.g50)
                                            Text("\(review.ratings.good)")
                                                .font(.suit(.regular, 15))
                                                .foregroundStyle(.g50)
                                        }
                                        Spacer()
                                        VStack(spacing: 8) {
                                            Image(name: Review.normalSoso)
                                            Text("평범해요")
                                                .font(.suit(.regular, 12))
                                                .foregroundStyle(.g50)
                                            Text("\(review.ratings.average)")
                                                .font(.suit(.regular, 15))
                                                .foregroundStyle(.g50)
                                        }
                                        Spacer()
                                        VStack(spacing: 8) {
                                            Image(name: Review.normalBad)
                                            Text("별로에요")
                                                .font(.suit(.regular, 12))
                                                .foregroundStyle(.g50)
                                            Text("\(review.ratings.bad)")
                                                .font(.suit(.regular, 15))
                                                .foregroundStyle(.g50)
                                        }
                                        Spacer()
                                    }
                                    .padding(.vertical, 16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(.g10, lineWidth: 1)
                                    )
                                }
                                .padding(.bottom, 32)
                            }
                            .offset(y: scrollOffset <= 0 ? 0 : -scrollOffset)
                            .padding(.horizontal, 16)
                        }
                        .edgesIgnoringSafeArea(.top)
                        .toolbar(.hidden, for: .navigationBar)
                        .toast(
                            message: "주소가 클립보드에 복사되었습니다.",
                            type: .check,
                            isShowing: $store.showToast.sending(\.toggleShowToast)
                        )
                    }
                } else {
                    ProgressView()
                        .toolbar(.hidden, for: .navigationBar)
                }
            }
            .onFirstAppear {
                store.send(.requestReviewDetail)
            }
        }
    }
}


#Preview {
    ReviewDetailView(store: .init(
        initialState: ReviewDetailFeature.State()) {
            ReviewDetailFeature()
        }
    )
}
