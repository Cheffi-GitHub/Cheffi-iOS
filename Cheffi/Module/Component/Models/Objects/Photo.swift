//
//  Photo.swift
//  Cheffi
//
//  Created by 정건호 on 6/27/24.
//

import Foundation

struct Photo: Codable, Equatable {
    let id: Int
    let order: Int
    let photoUrl: String
}
