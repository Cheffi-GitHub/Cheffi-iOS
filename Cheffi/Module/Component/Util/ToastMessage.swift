//
//  ToastMessage.swift
//  Cheffi
//
//  Created by 정건호 on 7/10/24.
//

import SwiftUI

enum ToastType {
    case normal
    case check
    case cancellable
}

struct ToastMessage: ViewModifier {
    let message: String
    let type: ToastType
    @Binding var isShowing: Bool
    var onCancel: (() -> Void)?
    
    @State private var dismissWorkItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        ZStack {
            content
            toastView
        }
    }
    
    private var toastView: some View {
        VStack {
            Spacer()
            Group {
                if isShowing {
                    if type == .normal {
                        Text(message)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                            .font(.suit(.medium, 16))
                            .onAppear {
                                dismissWork()
                            }
                    } else if type == .check {
                        HStack(spacing: 8) {
                            Image(name: Common.check)
                            Text(message)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .font(.suit(.medium, 16))
                                .onAppear {
                                    dismissWork()
                                }
                        }
                    } else if type == .cancellable {
                        HStack(spacing: 22) {
                            Text(message)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .font(.suit(.medium, 16))
                                .onAppear {
                                    dismissWork()
                                }
                            Text("취소")
                                .foregroundStyle(.gray7)
                                .font(.suit(.medium, 16))
                                .padding(EdgeInsets(top: 5, leading: 17, bottom: 5, trailing: 17))
                                .background(.gray05)
                                .clipShape(.rect(cornerRadius: 10))
                                .onTapGesture {
                                    isShowing = false
                                    dismissWorkItem?.cancel()
                                    onCancel?()
                                }
                        }
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 54)
            .padding(.horizontal, 12)
            .background(.toastGray)
            .cornerRadius(8)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 35)
        .animation(.linear(duration: 0.3), value: isShowing)
        .transition(.opacity)
    }
    
    private func dismissWork() {
        dismissWorkItem?.cancel()
        
        let workItem = DispatchWorkItem {
            isShowing = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: workItem)
        
        dismissWorkItem = workItem
    }
}
