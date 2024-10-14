//
//  ColorExtension.swift
//  Cheffi
//
//  Created by 정건호 on 5/28/24.
//

import SwiftUI

/*
 ex) Text("example")
        .foregroundStyle(Color(hex: 0xEB4451)
 */

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
