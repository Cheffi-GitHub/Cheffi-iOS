//
//  CollectionExtension.swift
//  Cheffi
//
//  Created by 권승용 on 11/11/24.
//

extension Collection {
    
    // 안전한 index 접근을 위한 subscript 제공
    subscript (safe index: Index) -> Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
}
