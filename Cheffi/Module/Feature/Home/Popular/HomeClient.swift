//
//  HomeClient.swift
//  Cheffi
//
//  Created by 정건호 on 6/27/24.
//

import Foundation
import Combine
import Alamofire
import ComposableArchitecture

@DependencyClient
struct HomeClient {
    var popularReviews: @Sendable (_ province: String, _ city: String, _ cursor: Int, _ size: Int) async throws -> PopularReviewResponse
    var tags: @Sendable (_ type: String) async throws -> TagsResponse
}

extension DependencyValues {
    var homeClient: HomeClient {
        get { self[HomeClient.self] }
        set { self[HomeClient.self] = newValue }
    }
}

extension HomeClient: DependencyKey {
    static var liveValue: Self {
        @Dependency(\.networkClient) var networkClient

        return HomeClient(
            popularReviews: { province, city, cursor, size in
                let publisher: AnyPublisher<PopularReviewResponse, AFError> = networkClient
                    .request(.popularReviews(province: province, city: city, cursor: cursor, size: size))
                    .eraseToAnyPublisher()
                
                return try await withCheckedThrowingContinuation { continuation in
                    var cancellable: AnyCancellable?
                    cancellable = publisher.sink(
                        receiveCompletion: { completion in
                            if case let .failure(error) = completion {
                                continuation.resume(throwing: error)
                            }
                            cancellable?.cancel()
                        },
                        receiveValue: { response in
                            continuation.resume(returning: response)
                        }
                    )
                }
            }, tags: { type in
                let publisher: AnyPublisher<TagsResponse, AFError> = networkClient
                    .request(.tags(type: type))
                    .eraseToAnyPublisher()
                
                return try await withCheckedThrowingContinuation { continuation in
                    var cancellable: AnyCancellable?
                    cancellable = publisher.sink(
                        receiveCompletion: { completion in
                            if case let .failure(error) = completion {
                                continuation.resume(throwing: error)
                            }
                            cancellable?.cancel()
                        },
                        receiveValue: { response in
                            continuation.resume(returning: response)
                        }
                    )
                }
            }
        )
    }
}
