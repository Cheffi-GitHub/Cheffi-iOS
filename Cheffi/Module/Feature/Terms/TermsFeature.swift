//
//  TermsFeature.swift
//  Cheffi
//
//  Created by 이서준 on 7/23/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TermsFeature {
    
    @ObservableState
    struct State: Equatable {
        var isSelectedAgreeAll: Bool = false
        var signupTerms: [SignupTerms] = []
        var isNextEnabled: Bool = false
    }
    
    enum Action {
        case onAppear
        case tappedAgreeAll
        case toggleTerms(SignupTerms)
        case updateAgreeAll
        case updateNextEnabled
        case presentTermsPage(URL)
        case presentWelcomeToCheffi
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.signupTerms = SignupTermsType.allCases.map {
                    SignupTerms(type: $0)
                }
                return .none
                
            case .tappedAgreeAll:
                state.signupTerms = state.signupTerms.map {
                    var updatedTerms = $0
                    updatedTerms.isSelected = true
                    return updatedTerms
                }
                return .merge([
                    .send(.updateAgreeAll),
                    .send(.updateNextEnabled)
                ])
                
            case .toggleTerms(let terms):
                state.signupTerms = state.signupTerms.map {
                    var updatedTerms = $0
                    if updatedTerms == terms {
                        updatedTerms.isSelected.toggle()
                    }
                    return updatedTerms
                }
                return .merge([
                    .send(.updateAgreeAll),
                    .send(.updateNextEnabled)
                ])
                
            case .updateAgreeAll:
                state.isSelectedAgreeAll = state.signupTerms
                    .allSatisfy { $0.isSelected }
                return .none
                
            case .updateNextEnabled:
                state.isNextEnabled = state.signupTerms
                    .filter { $0.type.isEssential }
                    .allSatisfy { $0.isSelected }
                return .none
                
            case .presentTermsPage(let url):
                // TODO: 약관 URL 링크 보여주기.. WebView? Safari?
                return .none
                
            case .presentWelcomeToCheffi:
                // TODO: 가입 완료! 쉐피에 오신걸 환영합니다!
                return .none
            }
        }
    }
}
