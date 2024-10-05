//
//  LineHeightModifier.swift
//  Cheffi
//
//  Created by 권승용 on 9/24/24.
//
import SwiftUI

struct LineHeightModifier: ViewModifier {
    let lineHeight: CGFloat
    let fontHeight: CGFloat
    
    public func body(content: Content) -> some View {
        content
            .lineSpacing(lineHeight - fontHeight)
            .padding(.vertical, (lineHeight - fontHeight) / 2)
    }
}
