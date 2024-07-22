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
    
    func onFirstAppear(_ action: @escaping () async -> Void) -> some View {
           modifier(FirstAppearModifer(action))
       }
}
