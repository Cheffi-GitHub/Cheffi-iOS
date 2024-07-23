//
//  ColorExtension.swift
//  Cheffi
//
//  Created by 정건호 on 5/28/24.
//

import SwiftUI

/*
 ex) Text("example")
        .foregroundStyle(Color.primary)
 */

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
    
    static let primary = Color(hex: 0xEB4351)
    
    static let sub1 = Color(hex: 0xFFBFC9)
    static let sub2 = Color(hex: 0xFF8EA0)
    
    static let grey05 = Color(hex: 0xF5F5F5)
    static let grey1 = Color(hex: 0xECECEC)
    static let grey2 = Color(hex: 0xD9D9D9)
    static let grey3 = Color(hex: 0xC5C5C5)
    static let grey4 = Color(hex: 0xB1B1B1)
    static let grey5 = Color(hex: 0x9E9E9E)
    static let grey6 = Color(hex: 0x808080)
    static let grey7 = Color(hex: 0x636363)
    static let grey8 = Color(hex: 0x454545)
    static let grey9 = Color(hex: 0x282828)
    
    static let black = Color(hex: 0x0A0A0A)
    static let white = Color(hex: 0xFFFFFF)
    
    static let dimmed = Color(hex: 0x000000, opacity: 0.4)
    static let alarm_bg = Color(hex: 0x707070, opacity: 0.9)
    
    static let background = Color(hex: 0xFFF2F4)
    
    static let `true` = Color(hex: 0x3972E1)
    static let `false` = Color(hex: 0xD82231)
    
    static let good = Color(hex: 0x437CEB)
    static let soso = Color(hex: 0x28DB85)
    static let bad = Color(hex: 0xF33D4C)
    
    static let littletime = Color(hex: 0xF63E4D)
    
    static let heart = Color(hex: 0xF65A68)
    
    static let expiration = Color(hex: 0xE53746)
}
