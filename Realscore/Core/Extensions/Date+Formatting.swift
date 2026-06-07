//
//  Date+Formatting.swift
//  Realscore
//

import Foundation

extension Date {    
    var displayDateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }

    var weekdayIndex: Int {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)

        // Sunday = 1, Monday = 2, ..., Saturday = 7
        // Desired: Monday = 0, Tuesday = 1, ..., Sunday = 6
        return (weekday + 5) % 7
    }

    var weekdayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "E"
        return formatter.string(from: self)
    }

    var dayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "dd.MM."
        return formatter.string(from: self)
    }

    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }
}
