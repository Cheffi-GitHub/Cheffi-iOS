//
//  ReviewCell.swift
//  Cheffi
//
//  Created by 정건호 on 6/3/24.
//

import SwiftUI
import Kingfisher

struct ReviewCell: View {
    let review: ReviewModel
    let type: ReviewType
    let screenWidth = UIWindow().screen.bounds.width
    
    init(review: ReviewModel = .dummyData, type: ReviewType) {
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
                        Color.grey05
                            .clipShape(.rect(cornerRadius: 8))
                        Image(name: Review.deletedImage)
                    } else {
                        if let url = URL(string: review.photo.photoUrl) {
                            KFImage(url)
                                .resizable()
                        } else {
                            Color.grey05
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
                
                HStack(spacing: 8) {
                    Image(name: Common.lock)
                    Text("00:30")
                        .foregroundStyle(Color.white)
                        .font(.suit(.semiBold, 14))
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 12)
                .background(Color.black.opacity(0.32))
                .clipShape(.rect(cornerRadius: 20))
                .padding([.top, .trailing], 10)
                .opacity(review.active ? 1 : 0)
            }
            Spacer().frame(height: 12)
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text(review.active ? review.title : "삭제된 리뷰입니다.")
                        .foregroundStyle(Color.black)
                        .font(.suit(.bold, 18))
                        .lineLimit(type == .small ? 2 : 1)
                    Spacer()
                    Image(name: Common.emptyHeart)
                        .hidden(!review.active)
                }
                Spacer().frame(height: 8)
                Text(review.text)
                    .foregroundStyle(Color.grey6)
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
    }
}

enum ReviewType {
    case small
    case medium
    case large
}

#Preview {
    ReviewCell(type: .medium)
}
