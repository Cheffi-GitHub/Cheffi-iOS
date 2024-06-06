//
//  PlaceCell.swift
//  Cheffi
//
//  Created by 정건호 on 6/3/24.
//

import SwiftUI

struct PlaceCell: View {
    let type: PlaceType
    let screenWidth = UIWindow().screen.bounds.width
    
    var body: some View {
        let smallSize = (screenWidth - 45) / 2
        let mediumHeight: CGFloat = 200
        let mediumWidth = screenWidth - 32
        let largeSize = screenWidth - 55
        
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                Image(name: Dummy.sample)
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
                    Text("그시절낭만의 근본 경양식 돈가스")
                        .foregroundStyle(Color.black)
                        .font(.suit(.bold, 18))
                        .lineLimit(type == .small ? 2 : 1)
                    Spacer()
                    Image(name: Common.emptyHeart)
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
    PlaceCell(type: .medium)
}
