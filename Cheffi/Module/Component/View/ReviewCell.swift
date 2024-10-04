//
//  ReviewCell.swift
//  Cheffi
//
//  Created by 정건호 on 6/3/24.
//

import SwiftUI
import Kingfisher

struct ReviewCell: View {
    
    @Environment(\.scenePhase) var scenePhase
    @State private var timeLeftToLock: Int = 0
    
    let review: ReviewModel
    let type: ReviewSize
    let screenWidth = UIWindow().screen.bounds.width
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(review: ReviewModel = .dummyData, type: ReviewSize) {
        self.review = review
        self.type = type
    }
    
    var body: some View {
        let smallSize = (screenWidth - 45) / 2
        let mediumHeight: CGFloat = 200
        let mediumWidth = screenWidth - 32
        let largeSize = screenWidth - 55
        
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                Group {
                    if !review.active {
                        Color.gray05
                            .clipShape(.rect(cornerRadius: 8))
                        Image(name: Review.deletedImage)
                    } else {
                        if let photoUrl = review.photo.photo.url,
                           let url = URL(string: photoUrl) {
                            KFImage(url)
                                .resizable()
                        } else {
                            Color.gray05
                                .clipShape(.rect(cornerRadius: 8))
                            Image(name: Review.deletedImage)
                        }
                    }
                }
                .frame(
                    width: type == .small
                    ? smallSize
                    : type == .medium
                    ? mediumWidth
                    : largeSize,
                    height: type == .small
                    ? smallSize
                    : type == .medium
                    ? mediumHeight
                    : largeSize
                )
                .clipShape(.rect(cornerRadius: 8))
                
                if !review.writtenByUser {
                    HStack(spacing: 8) {
                        Image(name: Common.lock)
                        Text(
                            review.purchased
                            ? "구매한 리뷰"
                            : timeLeftToLock == 0
                            ? "리뷰 잠김"
                            : timeLeftToLock >= 300
                            ? timeLeftToLock.toHourMinute()
                            : timeLeftToLock.toHourMinuteSecond()
                        )
                        .foregroundStyle(timeLeftToLock >= 300 || timeLeftToLock == 0 ? .white : .cheffiDark)
                        .font(.suit(.semiBold, 14))
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 12)
                    .background(.black.opacity(0.32))
                    .clipShape(.rect(cornerRadius: 20))
                    .padding([.top, .trailing], 10)
                    .opacity(review.active ? 1 : 0)
                }
            }
            Spacer().frame(height: 12)
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text(review.active ? review.title : "삭제된 리뷰입니다.")
                        .foregroundStyle(.black)
                        .font(.suit(.bold, 18))
                        .lineLimit(type == .small ? 2 : 1)
                    Spacer()
                    Image(name: Common.emptyHeart)
                        .hidden(!review.active)
                }
                Spacer().frame(height: 8)
                Text(review.text)
                    .foregroundStyle(.gray6)
                    .font(.suit(.regular, 15))
                    .lineLimit(type == .medium ? 1 : 2)
                    .hidden(!review.active)
            }
            .frame(
                width: type == .small
                ? smallSize
                : type == .medium
                ? mediumWidth
                : largeSize
            )
        }
        .onReceive(timer) { time in
            if timeLeftToLock > 0 {
                timeLeftToLock -= 1
            }
        }
        .onChange(of: scenePhase) { state in
            if state == .active {
                timeLeftToLock = review.timeToLock.secondsUntilLock()
            }
        }
        .onAppear {
            timeLeftToLock = review.timeToLock.secondsUntilLock()
        }
    }
}

enum ReviewSize {
    case small
    case medium
    case large
}

#Preview {
    ReviewCell(type: .medium)
}
