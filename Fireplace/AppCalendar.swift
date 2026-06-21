//
//  AppCalendar.swift
//  Fireplace
//
//  Created by Julia Wu on 21/06/2026.
//

import Foundation

extension Calendar {
    // returns the last day boundary passed before now, default boundary = 3am
    func startOfCustomDay(for date: Date = Date(), hour: Int = 3, minute: Int = 0) -> Date {
        let now = Date()

        var components = self.dateComponents([.year, .month, .day], from: now)
        components.hour = hour
        components.minute = minute
        components.second = 0
        
        guard let todayAtBoundary = self.date(from: components) else { return date }
        
        // If current time is BEFORE 3am, use yesterday's 3am
        if now < todayAtBoundary {
            return self.date(byAdding: .day, value: -1, to: todayAtBoundary) ?? todayAtBoundary
        }

        // Otherwise use today's 3am
        return todayAtBoundary
    }
}

