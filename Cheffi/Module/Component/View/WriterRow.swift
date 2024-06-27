//
//  WriterRow.swift
//  Cheffi
//
//  Created by 정건호 on 6/19/24.
//

import SwiftUI

struct WriterRow: View {
    let imageUrl: String
    let title: String
    let intro: String
    let isFollowed: Bool
    
    var body: some View {
        HStack {
            Image(name: Dummy.sample)
                .resizable()
                .frame(width: 64, height: 64)
                .clipShape(.rect(cornerRadius: 8))
            Spacer().frame(width: 12)
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .foregroundStyle(Color.black)
                    .font(.suit(.semiBold, 16))
                    .lineLimit(1)
                Text(intro)
                    .foregroundStyle(Color.grey5)
                    .font(.suit(.regular, 12))
                    .lineLimit(2)
            }
            Spacer().frame(minWidth: 32)
            
            Group {
                if isFollowed {
                    Text("팔로우")
                        .padding(.vertical, 6)
                        .padding(.horizontal, 20)
                        .background(Color.black)
                        .foregroundStyle(Color.white)
                        .font(.suit(.bold, 12))
                        .clipShape(.rect(cornerRadius: 8))
                } else {
                    Text("팔로잉")
                        .padding(.vertical, 6)
                        .padding(.horizontal, 20)
                        .foregroundStyle(Color.black)
                        .font(.suit(.bold, 12))
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(Color.grey2)
                        )
                }
            }
        }
        .frame(height: 64)
    }
}
