//
//  Writer.swift
//  Cheffi
//
//  Created by 정건호 on 7/9/24.
//

import Foundation

struct Writer: Codable, Equatable {
    let id: Int
    let nickname: String
    let photo: PhotoInfo
    let introduction: String
    let writtenByViewer: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case nickname
        case photo
        case introduction
        case writtenByViewer = "written_by_viewer"
    }
}
