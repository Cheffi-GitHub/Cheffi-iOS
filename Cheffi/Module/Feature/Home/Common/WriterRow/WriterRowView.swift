//
//  WriterRowView.swift
//  Cheffi
//
//  Created by 정건호 on 6/19/24.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

struct WriterRowView: View {
    let store: StoreOf<WriterRowFeature>
    
    var body: some View {
        HStack {
            NavigationLink(state: HomeFeature.Path.State.otherProfile(.init())) {
                Group {
                    if let photoUrl = store.photoUrl,
                       let url = URL(string: photoUrl) {
                        KFImage(url)
                            .resizable()
                    } else {
                        // TODO: 이미지 불러오지 못했을 때 UI 요청
                        Color.grey3
                    }
                }
                .frame(width: 64, height: 64)
                .clipShape(.rect(cornerRadius: 8))
                Spacer().frame(width: 12)
                VStack(alignment: .leading, spacing: 6) {
                    Text(store.title)
                        .foregroundStyle(Color.black)
                        .font(.suit(.semiBold, 16))
                        .lineLimit(1)
                    Text(store.intro)
                        .foregroundStyle(Color.grey5)
                        .font(.suit(.regular, 12))
                        .lineLimit(2)
                }
            }
            
            Spacer().frame(minWidth: 32)
            
            Group {
                if store.isFollowed {
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

#Preview {
    let store = StoreOf<WriterRowFeature>(
        initialState: WriterRowFeature.State(
            title: "title",
            intro: "intro",
            isFollowed: false
        )
    ) {
        WriterRowFeature()
    }
    WriterRowView(store: store)
}
