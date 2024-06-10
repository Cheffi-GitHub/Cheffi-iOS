//
//  ImageExtension.swift
//  Cheffi
//
//  Created by 정건호 on 6/2/24.
//

import SwiftUI

protocol ImageNameProtocol {
    var rawValue: String { get }
}

enum Common: String, ImageNameProtocol {
    case fillHeart = "fillHeart"
    case emptyHeart = "emptyHeart"
    case rightArrow = "rightArrow"
    case clock = "clock"
    case info = "info"
    case lock = "lock"
}

enum Tab: String, ImageNameProtocol {
    case normalHome = "normalHome"
    case selectedHome = "selectedHome"
    case normalTrend = "normalTrend"
    case selectedTrend = "selectedTrend"
    case write = "write"
    case normalMyPage = "normalMyPage"
    case selectedMyPage = "selectedMyPage"
}

enum Home: String, ImageNameProtocol {
    case search = "search"
    case alarm = "alarm"
    case previousPage = "previousPage"
    case nextPage = "nextPage"
}

// TODO: 추후 삭제
enum Dummy: String, ImageNameProtocol {
    case sample = "sample"
}

extension Image {
    init<T: ImageNameProtocol>(name: T) {
        self.init(name.rawValue)
    }
}
