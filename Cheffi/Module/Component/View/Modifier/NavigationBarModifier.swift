//
//  NavigationBarModifier.swift
//  Cheffi
//
//  Created by 이서준 on 8/7/24.
//

import SwiftUI

struct NavigationBarItem: Identifiable {
    let id = UUID()
    let image: Image
    let imageSize: CGSize
    let color: Color
    let action: () -> Void
    
    init(
        image: Image,
        imageSize: CGSize = CGSize(width: 24, height: 24),
        action: @escaping () -> Void,
        color: Color = .black
    ) {
        self.image = image
        self.imageSize = imageSize
        self.action = action
        self.color = color
    }
    
    static func backButton(action: @escaping () -> Void) -> NavigationBarItem {
        NavigationBarItem(image: Image(name: Common.leftArrow), action: action)
    }
    
    static func closeButton(action: @escaping () -> Void) -> NavigationBarItem {
        NavigationBarItem(
            image: Image(name: Common.xmark),
            imageSize: CGSize(width: 16, height: 16),
            action: action
        )
    }
}

struct NavigationBarModifier: ViewModifier {
    let title: String
    let leftBarItems: [NavigationBarItem]
    let rightBarItems: [NavigationBarItem]
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            ZStack {
                HStack(spacing: 0) {
                    ForEach(leftBarItems) { item in
                        Button(action: item.action) {
                            item.image
                                .resizable()
                                .renderingMode(.template)
                                .frame(size: item.imageSize)
                                .foregroundStyle(item.color)
                        }
                        .buttonStyle(.plain)
                        .frame(width: 44, height: 44)
                    }
                    .padding(.leading, 16)
                    
                    Spacer()
                    
                    HStack(spacing: 0) {
                        ForEach(rightBarItems) { item in
                            Button(action: item.action) {
                                item.image
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(size: item.imageSize)
                                    .foregroundStyle(item.color)
                            }
                            .buttonStyle(.plain)
                            .frame(width: 44, height: 44)
                        }
                    }
                    .padding(.trailing, 16)
                }
                
                Text(title)
                    .font(.suit(.semiBold, 16))
                    .foregroundStyle(.black)
            }
            .frame(height: 44)
            .background(.white)
            
            content
        }
        .toolbar(.hidden)
    }
}

extension View {
    func navigationBar(
        title: String,
        leftBarItems: [NavigationBarItem],
        rightBarItems: [NavigationBarItem] = []
    ) -> some View {
        self.modifier(
            NavigationBarModifier(
                title: title,
                leftBarItems: leftBarItems,
                rightBarItems: rightBarItems
            )
        )
    }
}
