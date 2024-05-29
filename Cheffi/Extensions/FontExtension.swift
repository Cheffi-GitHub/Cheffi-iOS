//
//  FontExtension.swift
//  Cheffi
//
//  Created by 정건호 on 5/28/24.
//

import SwiftUI

/*
 ex) Text("example")
        .font(.suit(.regular, 24))
 */

extension Font {
    enum Suit {
        case bold
        case extraBold
        case medium
        case regular
        case semiBold
        
        var value: String {
            switch self {
            case .bold:
                return "Suit-Bold"
            case .extraBold:
                return "Suit-ExtraBold"
            case .medium:
                return "Suit-Medium"
            case .regular:
                return "Suit-Regular"
            case .semiBold:
                return "Suit-SemiBold"
            }
        }
    }
    
    static func suit(_ font: Suit, _ size: CGFloat) -> Font {
        return .custom(font.value, size: size)
    }
}
