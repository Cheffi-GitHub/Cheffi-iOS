//
//  TermsView.swift
//  Cheffi
//
//  Created by 이서준 on 7/23/24.
//

import SwiftUI
import ComposableArchitecture

struct TermsView: View {
    
    @Perception.Bindable var store: StoreOf<TermsFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                Text("약관에 동의해주세요")
            }
        }
    }
}
