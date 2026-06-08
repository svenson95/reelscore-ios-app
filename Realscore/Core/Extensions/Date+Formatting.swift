//
//  Date+Formatting.swift
//  Realscore
//

import Foundation

extension Date {
    var weekdayIndex: Int {
        let weekday = Calendar.current.component(.weekday, from: self)
        return (weekday + 5) % 7
    }

    var weekdayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "E"
        return formatter.string(from: self)
    }

    var dayMonthString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "dd.MM."
        return formatter.string(from: self)
    }
    
    var dayMonthYearString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }

    func isSameDay(as other: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: other)
    }
}
