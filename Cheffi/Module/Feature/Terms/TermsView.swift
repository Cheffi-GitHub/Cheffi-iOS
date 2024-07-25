//
//  TermsView.swift
//  Cheffi
//
//  Created by 이서준 on 7/23/24.
//

import SwiftUI
import ComposableArchitecture

struct SignupTerms: Identifiable {
    var id = UUID()
    var isSelected: Bool = false
    var description: String
}

struct TermsView: View {
    
    @Perception.Bindable var store: StoreOf<TermsFeature>
    
    var signupTerms: [SignupTerms] = [
        SignupTerms(description: "[필수] 만 14세 이상입니다."),
        SignupTerms(description: "[필수] 서비스 이용 약관 동의"),
        SignupTerms(description: "[필수] 개인정보 수집 및 이용 동의"),
        SignupTerms(description: "[필수] 위치정보 이용동의 및 위치기반서비스 이용 동의"),
        SignupTerms(description: "[선택] 마케팅 정보 수신 동의"),
    ]
    
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
                        // TODO: 약관동의 상태 관리 -> Feature
                    }, label: {
                        HStack(alignment: .top, spacing: 0) {
                            Image(name: Terms.checkMarkCircle)
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
                
                List(signupTerms) { terms in
                    HStack(spacing: 0) {
                        Button(action: {
                            // TODO: 약관동의 상태 관리 -> Feature
                        }, label: {
                            HStack(spacing: 0) {
                                Image(name: Terms.checkMark)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .padding(.leading, 26)
                                
                                Text(terms.description)
                                    .font(.suit(.regular, 15))
                                    .foregroundStyle(Color.grey9)
                                    .padding(.leading, 14)
                            }
                        })
                        .buttonStyle(.plain)
                        
                        Spacer()
                        
                        Button(action: {
                            // TODO: Notion 약관 WebView
                        }, label: {
                            Image(name: Common.rightArrow)
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 24)
                                .foregroundStyle(Color.grey4)
                                .padding(.trailing, 26)
                        })
                    }
                    .listRowInsets(.init())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .padding(.top, 24)
                
                Spacer()
                
                Button(action: {
                    // TODO: 가입 완료!
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.grey1)
                        
                        Text("다음")
                            .font(.suit(.semiBold, 18))
                            .foregroundStyle(Color.grey5)
                    }
                })
                .frame(height: 48)
                .padding(.bottom, 16)
                .padding(.horizontal, 16)
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    TermsView(store: Store(initialState: TermsFeature.State()) {
        TermsFeature()
    })
}
