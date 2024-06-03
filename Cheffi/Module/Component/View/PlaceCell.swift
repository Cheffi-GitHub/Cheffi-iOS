//
//  PlaceCell.swift
//  Cheffi
//
//  Created by 정건호 on 6/3/24.
//

import SwiftUI

struct PlaceCell: View {
    let type: PlaceType = .medium
    
    var body: some View {
        let smallSize = (UIWindow().screen.bounds.width - 45) / 2
        let mediumHeight: CGFloat = 200
        let mediumWidth = UIWindow().screen.bounds.width - 32
        let largeSize = UIWindow().screen.bounds.width - 55
        
        VStack(spacing: 0) {
            Image(name: .sample)
                .resizable()
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
            Spacer().frame(height: 12)
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text("그시절낭만의 근본 경양식 돈가스")
                        .foregroundStyle(Color.black)
                        .font(.suit(.bold, 18))
                        .lineLimit(type == .small ? 2 : 1)
                    Spacer()
                    Image(name: .emptyHeart)
                }
                Spacer().frame(height: 8)
                Text("짬뽕 외길의 근본이 느껴지는 중식당짬뽕이 맛있는 집이 있습니다.")
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
    PlaceCell()
}
