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
        var signupTerms: [SignupTerms] = SignupTermsType.allCases.map { SignupTerms(type: $0) }
        var isNextEnabled: Bool = false
    }
    
    enum Action {
        case tappedAgreeAll
        case toggleTerms(SignupTerms)
        case updateAgreeAll
        case updateNextEnabled
        case navigateToTermsWebPage(URL)
        case navigateToWelcomeToCheffi
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
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
                
            case .navigateToTermsWebPage:
                return .none
                
            case .navigateToWelcomeToCheffi:
                return .none
            }
        }
    }
}
