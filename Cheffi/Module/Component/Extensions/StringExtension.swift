//
//  StringExtension.swift
//  Cheffi
//
//  Created by 정건호 on 7/10/24.
//

import Foundation

extension String {
    func timeAgo() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko-KR")
        
        guard let date = dateFormatter.date(from: self) else { return String() }
        
        let now = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.minute, .hour, .day, .month], from: date, to: now)
        
        if let months = components.month, months >= 1 {
            return "\(months)달 전"
        } else if let days = components.day, days >= 1 {
            return "\(days)일 전"
        } else if let hours = components.hour, hours < 24 {
            return "\(hours)시간 전"
        } else if let minutes = components.minute, minutes < 60 {
            return "방금 전"
        }
        
        return String()
    }
    
    func secondsUntilLock() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        
        let futureDate = dateFormatter.date(from: self) ?? Date()
        let timeInterval = futureDate.timeIntervalSince(Date())
        
        return timeInterval > 0 ? Int(timeInterval) : 0
    }
}
