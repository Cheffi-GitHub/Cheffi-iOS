//
//  ColorExtension.swift
//  Cheffi
//
//  Created by 정건호 on 5/28/24.
//

import SwiftUI

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

/* 
 Usage)
 Colors Asset 파일의 Color Resource별 hex 값 검색/참조만을 위한 열거형입니다.
 
 Figma의 hex 값으로 Xcode 프로젝트 내부 검색, Xcode15 ColorResource/Color 타입을 사용하세요.
 ex) .foregroundStyle(.cheffiPrimary)
 */
private enum ColorReference {
    case black          // 0A0A0A
    case white          // FFFFFF
    
    case cheffiDark     // E53746
    case cheffiLight    // FFF2F4
    case cheffiPrimary  // EB4351
    
    case gray05         // F5F5F5
    case gray1          // ECECEC
    case gray2          // D9D9D9
    case gray3          // C5C5C5
    case gray4          // B1B1B1
    case gray5          // 9E9E9E
    case gray6          // 808080
    case gray7          // 636363
    case gray8          // 454545
    case gray9          // 282828
    
    case toastGray      // 707070
}
