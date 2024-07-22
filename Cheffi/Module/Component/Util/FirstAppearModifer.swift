//
//  FirstAppearModifer.swift
//  Cheffi
//
//  Created by 정건호 on 7/14/24.
//

import SwiftUI

public struct FirstAppearModifer: ViewModifier {

    private let action: () async -> Void
    @State private var hasAppeared = false
    
    public init(_ action: @escaping () async -> Void) {
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        content
            .task {
                guard !hasAppeared else { return }
                hasAppeared = true
                await action()
            }
    }
}
