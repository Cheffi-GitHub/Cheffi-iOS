//
//  ViewExtension.swift
//  Cheffi
//
//  Created by 정건호 on 7/10/24.
//

import SwiftUI

extension View {
    func toast(
        message: String,
        type: ToastType,
        isShowing: Binding<Bool>,
        onCancel: (() -> Void)? = nil
    ) -> some View {
        self.modifier(
            ToastMessage(
                message: message,
                type: type,
                isShowing: isShowing,
                onCancel: onCancel
            )
        )
    }
    
    func hidden(_ hidden: Bool) -> some View {
        opacity(hidden ? 0 : 1)
    }
    
    func onFirstAppear(_ action: @escaping () async -> Void) -> some View {
        modifier(FirstAppearModifer(action))
    }
    
    func lineHeight(_ height: CGFloat, fontHeight: CGFloat) -> some View {
        modifier(LineHeightModifier(lineHeight: height, fontHeight: fontHeight))
    }
  
    func frame(size: CGSize) -> some View {
        self.frame(width: size.width, height: size.height)
    }
}
