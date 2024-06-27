//
//  LaunchScreenView.swift
//  Cheffi
//
//  Created by 이서준 on 6/26/24.
//

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            Color.cheffiPrimary
                .ignoresSafeArea()
            
            Image("launchScreenLogo")
                .resizable()
                .frame(width: 120, height: 36)
        }
    }
}

#Preview {
    LaunchScreenView()
}
