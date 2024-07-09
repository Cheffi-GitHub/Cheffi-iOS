//
//  Ratings.swift
//  Cheffi
//
//  Created by 정건호 on 7/9/24.
//

import Foundation

struct Ratings: Codable, Equatable {
    let good: Int
    let average: Int
    let bad: Int
    
    enum CodingKeys: String, CodingKey {
        case good = "GOOD"
        case average = "AVERAGE"
        case bad = "BAD"
    }
}
