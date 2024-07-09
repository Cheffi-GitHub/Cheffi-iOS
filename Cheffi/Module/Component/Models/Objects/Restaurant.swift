//
//  Restaurant.swift
//  Cheffi
//
//  Created by 정건호 on 7/9/24.
//

import Foundation

struct Restaurant: Codable, Equatable {
    let id: Int
    let name: String
    let address: Address
    let registered: Bool
}
