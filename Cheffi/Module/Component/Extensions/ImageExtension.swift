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
    case leftArrow = "leftArrow"
    case clock = "clock"
    case info = "info"
    case lock = "lock"
    case check = "check"
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
    case homeEmpty = "homeEmpty"
    case normalCollapse = "normalCollapse"
    case selectedCollapse = "selectedCollapse"
    case normalExpand = "normalExpand"
    case selectedExpand = "selectedExpand"
    case popularTooptip = "popularTooptip"
    case placeTooltip = "placeTooltip"
}

enum Review: String, ImageNameProtocol {
    case dots = "dots"
    case normalGood = "normalGood"
    case normalSoso = "normalSoso"
    case normalBad = "normalBad"
    case selectedGood = "selectedGood"
    case selectedSoso = "selectedSoso"
    case selectedBad = "selectedBad"
}

enum Login: String, ImageNameProtocol {
    case loginKakao = "loginKakao"
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
