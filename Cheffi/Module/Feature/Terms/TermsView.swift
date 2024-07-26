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
            VStack(alignment: .leading, spacing: 0) {
                Text("약관에 동의해주세요")
                    .font(.suit(.semiBold, 22))
                    .foregroundStyle(Color.grey9)
                    .padding(.leading, 16)
                    .padding(.top, 68)
                
                VStack(alignment: .leading, spacing: 0) {
                    Button(action: {
                        store.send(.tappedAgreeAll)
                    }, label: {
                        HStack(alignment: .top, spacing: 0) {
                            Image(
                                name: store.isSelectedAgreeAll
                                ? Terms.checkMarkCircleFill
                                : Terms.checkMarkCircle
                            )
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.leading, 26)
                            
                            Text("약관 전체동의")
                                .font(.suit(.semiBold, 18))
                                .foregroundStyle(Color.grey9)
                                .padding(.leading, 18)
                        }
                    })
                    .buttonStyle(.plain)
                    
                    Text("서비스 이용을 위해 다음의 약관에 모두 동의합니다.")
                        .font(.suit(.regular, 14))
                        .foregroundStyle(Color.grey4)
                        .padding(.top, 14)
                        .padding(.leading, 68)
                }
                .padding(.top, 38)
                
                Divider()
                    .foregroundStyle(Color.grey05)
                    .frame(height: 1)
                    .padding(.top, 16)
                
                List(store.signupTerms) { terms in
                    HStack(spacing: 0) {
                        Button(action: {
                            store.send(.toggleTerms(terms))
                        }, label: {
                            HStack(spacing: 0) {
                                Image(
                                    name: terms.isSelected
                                    ? Terms.checkMarkFill
                                    : Terms.checkMark
                                )
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(.leading, 26)
                                
                                Text(terms.type.description)
                                    .font(.suit(.regular, 15))
                                    .foregroundStyle(Color.grey9)
                                    .padding(.leading, 14)
                            }
                        })
                        .buttonStyle(.plain)
                        
                        Spacer()
                        
                        if let url = terms.type.url {
                            Button(action: {
                                store.send(.presentTermsPage(url))
                            }, label: {
                                Image(name: Common.rightArrow)
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(Color.grey4)
                                    .padding(.trailing, 26)
                            })
                        }
                    }
                    .listRowInsets(.init())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .padding(.top, 24)
                
                Spacer()
                
                Button(action: {
                    store.send(.presentWelcomeToCheffi)
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(
                                store.isNextEnabled
                                ? Color.primary
                                : Color.grey1
                            )
                        
                        Text("다음")
                            .font(.suit(.semiBold, 18))
                            .foregroundStyle(
                                store.isNextEnabled
                                ? Color.white
                                : Color.grey5
                            )
                    }
                })
                .frame(height: 48)
                .padding(.bottom, 16)
                .padding(.horizontal, 16)
                .disabled(!store.isNextEnabled)
            }
            .navigationBarBackButtonHidden()
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}

#Preview {
    TermsView(store: Store(initialState: TermsFeature.State()) {
        TermsFeature()
    })
}
