//
//  Date+Week.swift
//  Realscore
//

import Foundation

extension Date {
    init?(isoString: String) {
        let formatter = ISO8601DateFormatter()

        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds,
        ]

        if let date = formatter.date(from: isoString) {
            self = date
            return
        }

        formatter.formatOptions = [
            .withInternetDateTime
        ]

        if let date = formatter.date(from: isoString) {
            self = date
            return
        }

        return nil
    }

    var startOfWeek: Date {
        let calendar = Calendar.appCalendar
        let components = calendar.dateComponents(
            [.yearForWeekOfYear, .weekOfYear],
            from: self
        )

        return calendar.date(from: components) ?? self
    }

    var apiDateString: String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.appCalendar
        formatter.dateFormat = "yyyy-MM-dd"

        return formatter.string(from: self)
    }
}
