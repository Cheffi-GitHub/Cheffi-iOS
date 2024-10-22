//
//  ColorResource.swift
//  Cheffi
//
//  Created by 이서준 on 10/22/24.
//

import SwiftUI

/*
 Colors.assets에 추가된 색상 값의 이름을
 소문자로 생성하여도, 대문자로 변경되어 생성되는 문제가 있어요.
 대문자로 생성되는 경우 알파벳과 숫자가 언더바(_)로
 나뉘게 되어 네이밍 의도와 달라지기에 프로퍼티를 개별 선언하였습니다.
 */

extension Color {
    // Gray
    static let g10 = ColorResource.G_10
    static let g20 = ColorResource.G_20
    static let g30 = ColorResource.G_30
    static let g40 = ColorResource.G_40
    static let g50 = ColorResource.G_50
    static let g60 = ColorResource.G_60
    static let g70 = ColorResource.G_70
    static let g80 = ColorResource.G_80
    static let g90 = ColorResource.G_90
    static let g100 = ColorResource.G_100
    
    // Main
    static let m10 = ColorResource.M_10
    static let m20 = ColorResource.M_20
    static let m30 = ColorResource.M_30
    static let m40 = ColorResource.M_40
    static let m50 = ColorResource.M_50
    static let m60 = ColorResource.M_60
    static let m70 = ColorResource.M_70
    static let m80 = ColorResource.M_80
    static let m90 = ColorResource.M_90
    static let m100 = ColorResource.M_100
    
    // MainSub
    static let ms10 = ColorResource.MS_10
    static let ms20 = ColorResource.MS_20
    static let ms30 = ColorResource.MS_30
    static let ms40 = ColorResource.MS_40
    static let ms50 = ColorResource.MS_50
    static let ms60 = ColorResource.MS_60
    static let ms70 = ColorResource.MS_70
    static let ms80 = ColorResource.MS_80
    static let ms90 = ColorResource.MS_90
    static let ms100 = ColorResource.MS_100
    
    // SubBlue
    static let sb01 = ColorResource.SB_01
    static let sb02 = ColorResource.SB_02
    
    // SubGreen
    static let sg01 = ColorResource.SG_01
    
    // SubRed
    static let sr01 = ColorResource.SR_01
    static let sr02 = ColorResource.SR_02
}
