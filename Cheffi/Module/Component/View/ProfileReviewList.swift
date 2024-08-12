//
//  ProfileReviewList.swift
//  Cheffi
//
//  Created by 정건호 on 8/12/24.
//

import SwiftUI

struct ProfileReviewList: View {
    
    private let columns = [
        GridItem(.flexible(), alignment: .top),
        GridItem(.flexible(), alignment: .top)
    ]
    
    var type: ProfileReviewType
    var reviews: [ReviewModel]?
    var hasNext: Bool?
    let pagingAction: () -> Void
    
    init(
        type: ProfileReviewType,
        reviews: [ReviewModel]? = nil,
        hasNext: Bool?,
        pagingAction: @escaping () -> Void
    ) {
        self.type = type
        self.reviews = reviews
        self.hasNext = hasNext
        self.pagingAction = pagingAction
    }
    
    var body: some View {
        ScrollView {
            if let reviews = reviews, reviews.count != 0 {
                    LazyVGrid(columns: columns, spacing: 24) {
                        ForEach(0..<reviews.count, id: \.self) { index in
                            ReviewCell(review: reviews[index], type: .small)
                        }
                    }
                    .padding(.horizontal, 16)
            } else {
                HStack {
                    Spacer()
                    VStack(spacing: 14) {
                        Image(name: type == .review
                              ? Profile.reviewsEmpty
                              : type == .purchase
                              ? Profile.purchaseEmpty
                              : Profile.bookmarksEmpty
                        )
                        Text(type == .review
                             ? "작성한 리뷰가 없어요"
                             : type == .purchase
                             ? "구매한 리뷰가 없어요"
                             : "찜한 리뷰가 없어요"
                        )
                            .font(.suit(.regular, 16))
                            .foregroundStyle(Color.grey6)
                    }
                    .frame(height: 400)
                    Spacer()
                }
            }
        }
        .padding(.top, 20)
    }
}

enum ProfileReviewType {
    case review
    case purchase
    case bookmark
}

