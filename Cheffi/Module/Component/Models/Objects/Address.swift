//
//  Address.swift
//  Cheffi
//
//  Created by 정건호 on 7/9/24.
//

import Foundation

struct Address: Codable, Equatable {
    let province: String
    let city: String
    let roadName: String
    let fullLotNumberAddress: String
    let fullRoadNameAddress: String
    
    enum CodingKeys: String, CodingKey {
        case province
        case city
        case roadName = "road_name"
        case fullLotNumberAddress = "full_lot_number_address"
        case fullRoadNameAddress = "full_rod_name_address"
    }
}
