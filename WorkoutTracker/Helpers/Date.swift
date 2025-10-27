//
//  Date.swift
//  WorkoutTracker
//
//  Created by Darrell Ng on 24/10/25.
//

import Foundation

extension Date {
    func calendarDateRange() -> ClosedRange<Date> {
        let calendar = Calendar.current
        let currentDate = Date()
        let distantPast = calendar.date(byAdding: .year, value: -50, to: currentDate)!
        let startOfCurrentDay = calendar.startOfDay(for: currentDate)
        return distantPast...startOfCurrentDay
    }
}

