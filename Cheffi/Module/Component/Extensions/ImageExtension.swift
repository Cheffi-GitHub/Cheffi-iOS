//
//  ImageExtension.swift
//  Cheffi
//
//  Created by 정건호 on 6/2/24.
//

import SwiftUI

extension Image {
    enum ImageName: String {
        // 공통
        case fillHeart = "fillHeart"
        case emptyHeart = "emptyHeart"
        case rightArrow = "rightArrow"
        case clock = "clock"
        case info = "info"
        
        // 탭뷰 관련
        case normalHome = "normalHome"
        case selectedHome = "selectedHome"
        case normalTrend = "normalTrend"
        case selectedTrend = "selectedTrend"
        case write = "write"
        case normalMyPage = "normalMyPage"
        case selectedMyPage = "selectedMyPage"
        
        // 홈 화면
        case search = "search"
        case alarm = "alarm"
      
        // TODO: 추후 삭제
        case sample = "sample"
    }
    
    init(name imageName: ImageName) {
        self.init(imageName.rawValue)
    }
}
