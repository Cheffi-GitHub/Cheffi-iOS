//
//  PlainList.swift
//  Cheffi
//
//  Created by 정건호 on 8/12/24.
//

import SwiftUI

struct PlainList<Content: View>: View {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        List {
            content
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
        }
        .listStyle(PlainListStyle())
        .buttonStyle(PlainButtonStyle())
    }
}
