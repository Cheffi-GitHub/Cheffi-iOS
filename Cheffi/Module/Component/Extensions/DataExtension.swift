//
//  DataExtension.swift
//  Cheffi
//
//  Created by 이서준 on 6/13/24.
//

import Foundation

extension Data {
    var toPrettyPrintedString: String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(
            with: self,
            options: []
        ), let data = try? JSONSerialization.data(
            withJSONObject: jsonObject,
            options: [.prettyPrinted]
        ), let prettyPrintedString = NSString(
            data: data,
            encoding: String.Encoding.utf8.rawValue
        ) else {
            return nil
        }
        return prettyPrintedString as String
    }
}
