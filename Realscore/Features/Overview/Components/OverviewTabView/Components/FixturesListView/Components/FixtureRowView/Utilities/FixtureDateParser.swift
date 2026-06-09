//
//  FixtureDateParser.swift
//  Realscore
//

import Foundation

enum FixtureDateParser {
    static func parse(_ value: String) -> Date? {
        if let date = withFractionalSeconds.date(from: value) {
            return date
        }

        return withoutFractionalSeconds.date(from: value)
    }

    static let kickoffTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = .appCalendar
        formatter.locale = .appLocale
        formatter.timeZone = .appTimeZone
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    private static let withFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        return formatter
    }()

    private static let withoutFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime
        ]
        return formatter
    }()
}
