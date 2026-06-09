//
//  Date+Formatting.swift
//  Realscore
//

import Foundation

extension Date {
    var weekdayIndex: Int {
        let weekday = Calendar.appCalendar.component(.weekday, from: self)
        return (weekday + 5) % 7
    }

    var weekdayString: String {
        Self.weekdayFormatter.string(from: self)
            .replacingOccurrences(of: ".", with: "")
    }

    var dayMonthString: String {
        Self.dayMonthFormatter.string(from: self)
    }

    var dayMonthYearString: String {
        Self.dayMonthYearFormatter.string(from: self)
    }
}

private extension Date {
    static let weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = .appCalendar
        formatter.locale = .appLocale
        formatter.timeZone = .appTimeZone
        formatter.dateFormat = "E"
        return formatter
    }()

    static let dayMonthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = .appCalendar
        formatter.locale = .appLocale
        formatter.timeZone = .appTimeZone
        formatter.dateFormat = "dd.MM"
        return formatter
    }()

    static let dayMonthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = .appCalendar
        formatter.locale = .appLocale
        formatter.timeZone = .appTimeZone
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
}
