//
//  AddRestaurantView.swift
//  Cheffi
//
//  Created by 권승용 on 10/12/24.
//

import SwiftUI
import ComposableArchitecture

struct AddRestaurantView: View {
    
    @Perception.Bindable var store: StoreOf<AddRestaurantFeature> = .init(
        initialState: AddRestaurantFeature.State()) {
            AddRestaurantFeature()
        }
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            HStack {
                Image(.xmark)
                    .frame(width: 44, height: 44)
                    .onTapGesture {
                        dismiss()
                    }
                Spacer()
            }
            .padding(.horizontal, 16)
            VStack {
                Spacer()
                Text("맛집 등록 뷰")
                Spacer()
            }
        }
    }
}

#Preview {
    AddRestaurantView()
}
