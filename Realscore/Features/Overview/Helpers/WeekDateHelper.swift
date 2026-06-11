//
//  WeekDateHelper.swift
//  Realscore
//

import Foundation

enum WeekDateHelper {
    static func start(for date: Date) -> Date {
        let calendar = Calendar.appCalendar
        let normalizedDate = calendar.startOfDay(for: date)

        let weekday = calendar.component(.weekday, from: normalizedDate)
        let daysSinceMonday = (weekday + 5) % 7

        return calendar.date(
            byAdding: .day,
            value: -daysSinceMonday,
            to: normalizedDate
        ) ?? normalizedDate
    }

    static func day(for date: Date) -> Date {
        Calendar.appCalendar.startOfDay(for: date)
    }

    static func addDays(_ days: Int, to date: Date) -> Date? {
        Calendar.appCalendar.date(
            byAdding: .day,
            value: days,
            to: date
        )
    }

    static func dates(from weekStart: Date, edge: Bool = true) -> [Date] {
        let calendar = Calendar.appCalendar
        let start = calendar.startOfDay(for: weekStart)

        let week = (0..<7).compactMap { offset in
            calendar.date(
                byAdding: .day,
                value: offset,
                to: start
            ).map {
                calendar.startOfDay(for: $0)
            }
        }

        guard edge else {
            return week
        }

        guard
            let previousEdgeDay = calendar.date(
                byAdding: .day,
                value: -1,
                to: start
            ).map({ calendar.startOfDay(for: $0) }),
            let nextEdgeDay = calendar.date(
                byAdding: .day,
                value: 7,
                to: start
            ).map({ calendar.startOfDay(for: $0) })
        else {
            return week
        }

        return [previousEdgeDay] + week + [nextEdgeDay]
    }

    static func realWeekdayIndex(for date: Date) -> Int {
        let calendar = Calendar.appCalendar
        let normalizedDate = calendar.startOfDay(for: date)
        let weekStart = start(for: normalizedDate)

        let dayOffset = calendar.dateComponents(
            [.day],
            from: weekStart,
            to: normalizedDate
        ).day ?? 0

        return Constants.firstRealWeekdayIndex + dayOffset
    }
}
