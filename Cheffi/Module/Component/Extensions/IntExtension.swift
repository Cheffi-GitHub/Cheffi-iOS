//
//  IntExtension.swift
//  Cheffi
//
//  Created by 정건호 on 7/13/24.
//

import Foundation

extension Int {
    func toHourMinuteSecond() -> String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = self % 60
        return String(format: "%02d : %02d : %02d", hours, minutes, seconds)
    }
    
    func toHourMinute() -> String {
          let hours = self / 3600
          let minutes = (self % 3600) / 60
          return String(format: "%02d : %02d", hours, minutes)
      }
}
