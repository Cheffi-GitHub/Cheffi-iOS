//
//  PlaceCell.swift
//  Cheffi
//
//  Created by 정건호 on 6/3/24.
//

import SwiftUI
import Kingfisher

struct PlaceCell: View {
    let review: ReviewModel
    let type: PlaceType
    let screenWidth = UIWindow().screen.bounds.width
    
    init(review: ReviewModel = .dummyData, type: PlaceType) {
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
                    if let url = URL(string: review.photo.photoUrl) {
                        KFImage(url)
                            .resizable()
                    } else {
                        // TODO: 이미지 불러오지 못했을 때 UI 요청
                        Color.grey3
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
                
            }
            Spacer().frame(height: 12)
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text(review.title)
                        .foregroundStyle(Color.black)
                        .font(.suit(.bold, 18))
                        .lineLimit(type == .small ? 2 : 1)
                    Spacer()
                    Image(name: Common.emptyHeart)
                }
                Spacer().frame(height: 8)
                Text(review.text)
                    .foregroundStyle(Color.grey6)
                    .font(.suit(.regular, 15))
                    .lineLimit(type == .medium ? 1 : 2)
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

enum PlaceType {
    case small
    case medium
    case large
}

#Preview {
    PlaceCell(type: .medium)
}
