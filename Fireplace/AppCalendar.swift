//
//  AppCalendar.swift
//  Fireplace
//
//  Created by Julia Wu on 21/06/2026.
//

import Foundation

extension Calendar {
    
    var customDayStartHour: Int { return 3 }
    var customDayStartMinute: Int { return 0 }
    
    // returns the last day boundary passed before date, default boundary = 3am
    func startOfCustomDay(for date: Date = Date()) -> Date {

        var components = self.dateComponents([.year, .month, .day], from: date)
        components.hour = customDayStartHour
        components.minute = customDayStartMinute
        components.second = 0
        
        guard let todayAtBoundary = self.date(from: components) else { return date }
        
        // If current time is BEFORE 3am, use yesterday's 3am
        if date < todayAtBoundary {
            return self.date(byAdding: .day, value: -1, to: todayAtBoundary) ?? todayAtBoundary
        }

        // Otherwise use today's 3am
        return todayAtBoundary
    }
}

