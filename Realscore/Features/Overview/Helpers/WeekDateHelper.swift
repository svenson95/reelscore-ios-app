//
//  WeekDateHelper.swift
//  Realscore
//

import Foundation

enum WeekDateHelper {
    static func start(for date: Date) -> Date {
        let calendar = Calendar.appCalendar

        let components = calendar.dateComponents(
            [.yearForWeekOfYear, .weekOfYear],
            from: date
        )

        return calendar.date(from: components) ?? calendar.startOfDay(for: date)
    }

    static func addDays(_ days: Int, to date: Date) -> Date? {
        Calendar.appCalendar.date(byAdding: .day, value: days, to: date)
    }

    static func dates(from weekStart: Date, edge: Bool = true) -> [Date] {
        let calendar = Calendar.appCalendar
        let start = calendar.startOfDay(for: weekStart)

        let week = (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: start)
        }

        guard edge else {
            return week
        }

        guard
            let previousEdgeDay = calendar.date(byAdding: .day, value: -1, to: start),
            let nextEdgeDay = calendar.date(byAdding: .day, value: 7, to: start)
        else {
            return week
        }

        return [previousEdgeDay] + week + [nextEdgeDay]
    }
}
