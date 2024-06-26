//
//  KeychainManager.swift
//  Cheffi
//
//  Created by 이서준 on 6/23/24.
//

import Foundation
import Security

class KeychainManager {
    
    static let shared = KeychainManager()
    
    private init() { }
    
    func save(_ data: Any, for key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // 저장되어있던 데이터는 새로 쓰기
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func load<T: Any>(for key: String) -> T? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeReference: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeReference)
        if status == errSecSuccess {
            return dataTypeReference as? T
        }
        
        return nil
    }
    
    func delete(for key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
