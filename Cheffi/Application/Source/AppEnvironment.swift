//
//  AppEnvironment.swift
//  Cheffi
//
//  Created by 이서준 on 6/10/24.
//

import Foundation

enum AppEnvironmentError: Error {
    case notFoundPlist
    case notFoundProperty
    case typeCasting
}

/*
    Usage)
     do {
         let baseURL: String = try AppEnvironment.baseURL.getValue()
         print(baseURL)
     } catch {
         print(error)
     }
 */

enum AppEnvironment: String {
    case baseURL = "BASE_URL"
}

extension AppEnvironment {
    func getValue<T>() throws -> T {
        guard let fileURL = Bundle.main.url(forResource: "Info", withExtension: "plist") else {
            throw AppEnvironmentError.notFoundPlist
        }
        
        guard let data = try? Data(contentsOf: fileURL),
              let dictionary = try? PropertyListSerialization.propertyList(
                from: data,
                format: nil
              ) as? NSDictionary else {
            throw AppEnvironmentError.notFoundProperty
        }
        
        guard let value = dictionary[self.rawValue] as? T else {
            throw AppEnvironmentError.typeCasting
        }
        
        return value
    }
}
