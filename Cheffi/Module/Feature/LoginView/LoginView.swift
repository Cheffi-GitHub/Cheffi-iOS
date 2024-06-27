//
//  LoginView.swift
//  Cheffi
//
//  Created by 이서준 on 6/17/24.
//

import SwiftUI

struct LoginView: View {
    
    var body: some View {
        VStack {
            Spacer()
            
            Button(action: {
                print("tapped login")
            }, label: {
                Image(name: Login.loginKakao)
            })
            .frame(idealHeight: 56)
            .padding(.bottom, 152)
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    LoginView()
}
