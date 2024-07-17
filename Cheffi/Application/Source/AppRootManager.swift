//
//  AppRootManager.swift
//  Cheffi
//
//  Created by 이서준 on 7/17/24.
//

import Foundation

final class AppRootManager: ObservableObject {
    
    @Published var currentRoot: CheffiAppRoot = .launchScreen
    
    enum CheffiAppRoot {
        case launchScreen
        case login
        case main
    }
}
