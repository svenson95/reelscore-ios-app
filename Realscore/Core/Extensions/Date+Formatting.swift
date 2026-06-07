//
//  Date+Formatting.swift
//  Realscore
//

import Foundation

extension Date {
    var apiDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }

    var displayDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }

    var weekdayIndexMondayBased: Int {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)

        // Calendar weekday:
        // Sunday = 1, Monday = 2, ..., Saturday = 7
        //
        // Desired:
        // Monday = 0, Tuesday = 1, ..., Sunday = 6
        return (weekday + 5) % 7
    }
}
