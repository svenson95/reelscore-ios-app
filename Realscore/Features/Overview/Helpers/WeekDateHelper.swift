//
//  WeekDateHelper.swift
//  Realscore
//

import Foundation

enum WeekDateHelper {
    static func start(for date: Date) -> Date {
        let calendar = Calendar.current
        let day = calendar.startOfDay(for: date)
        let offset = day.weekdayIndex

        let monday = calendar.date(
            byAdding: .day,
            value: -offset,
            to: day
        ) ?? day

        return calendar.startOfDay(for: monday)
    }

    static func dates(from weekStart: Date, edge: Bool = true) -> [Date] {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: weekStart)

        let week = (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: start)
        }

        guard edge else {
            return week
        }

        guard
            let prev = calendar.date(byAdding: .day, value: -1, to: start),
            let next = calendar.date(byAdding: .day, value: 7, to: start)
        else {
            return week
        }

        return [prev] + week + [next]
    }

    static func addDays(_ days: Int, to date: Date) -> Date? {
        Calendar.current.date(
            byAdding: .day,
            value: days,
            to: date
        )
    }
}
