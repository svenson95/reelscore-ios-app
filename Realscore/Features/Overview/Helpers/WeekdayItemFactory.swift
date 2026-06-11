//
//  WeekdayItemFactory.swift
//  Realscore
//

import Foundation

enum WeekdayItemFactory {
    static func empty(from weekStart: Date) -> [WeekdayItem] {
        WeekDateHelper.dates(from: weekStart).map {
            WeekdayItem(date: $0, fixtures: [])
        }
    }

    static func make(
        dates: [Date],
        fixtures: [[Fixture]]
    ) -> [WeekdayItem]? {
        let flattenedFixtures = fixtures.flatMap { $0 }

        return make(
            dates: dates,
            fixtures: flattenedFixtures
        )
    }

    static func make(
        dates: [Date],
        fixtures: [Fixture]
    ) -> [WeekdayItem]? {
        guard !dates.isEmpty else {
            return []
        }

        return dates.map { date in
            WeekdayItem(
                date: date,
                fixtures: fixtures.filter { fixture in
                    guard let fixtureDate = fixtureDate(for: fixture) else {
                        return false
                    }

                    return Calendar.appCalendar.isDate(
                        fixtureDate,
                        inSameDayAs: date
                    )
                }
            )
        }
    }

    private static func fixtureDate(for fixture: Fixture) -> Date? {
        WeekdayDateParser.date(from: fixture.fixture.date)
    }
}

private enum WeekdayDateParser {
    static let formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        return formatter
    }()

    static func date(from string: String) -> Date? {
        formatter.date(from: string)
    }
}
