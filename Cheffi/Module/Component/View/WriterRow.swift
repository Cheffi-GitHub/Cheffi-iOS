//
//  WriterRow.swift
//  Cheffi
//
//  Created by 정건호 on 6/19/24.
//

import SwiftUI
import Kingfisher

struct WriterRow: View {
    let photoUrl: String?
    let title: String
    let intro: String
    let isFollowed: Bool
    
    var body: some View {
        HStack {
            Group {
                if let photoUrl = photoUrl,
                   let url = URL(string: photoUrl) {
                    KFImage(url)
                        .resizable()
                } else {
                    // TODO: 이미지 불러오지 못했을 때 UI 요청
                    Color.gray3
                }
            }
            .frame(width: 64, height: 64)
            .clipShape(.rect(cornerRadius: 8))
            Spacer().frame(width: 12)
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .foregroundStyle(.black)
                    .font(.suit(.semiBold, 16))
                    .lineLimit(1)
                Text(intro)
                    .foregroundStyle(.gray5)
                    .font(.suit(.regular, 12))
                    .lineLimit(2)
            }
            Spacer().frame(minWidth: 32)
            
            Group {
                if isFollowed {
                    Text("팔로우")
                        .padding(.vertical, 6)
                        .padding(.horizontal, 20)
                        .background(.black)
                        .foregroundStyle(.white)
                        .font(.suit(.bold, 12))
                        .clipShape(.rect(cornerRadius: 8))
                } else {
                    Text("팔로잉")
                        .padding(.vertical, 6)
                        .padding(.horizontal, 20)
                        .foregroundStyle(.black)
                        .font(.suit(.bold, 12))
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(.gray2)
                        )
                }
            }
        }
        .frame(height: 64)
    }
}
