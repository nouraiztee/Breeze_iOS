//
//  DateExtension.swift
//  Breeze
//
//  Created by Nouraiz Taimour on 02/03/2024.
//

import Foundation

extension Date {
    func getDayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEE")
        return dateFormatter.string(from: self)
    }
    
    public func addOrSubtractDay(day:Int) -> Date{
      return Calendar.current.date(byAdding: .day, value: day, to: Date())!
    }
}
