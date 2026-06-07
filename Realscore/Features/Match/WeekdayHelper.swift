//
//  WeekdayHelper.swift
//  Realscore
//

import Foundation

struct WeekdayItem: Identifiable {
    let id = UUID()
    let date: Date
    let weekdayLabel: String
    let dayLabel: String
}

enum WeekdayHelper {
    static func currentWorkWeek() -> [WeekdayItem] {
        let calendar = Calendar.current
        let today = Date()

        let weekday = calendar.component(.weekday, from: today)

        // Swift Calendar:
        // Sunday = 1, Monday = 2, ..., Saturday = 7
        let daysFromMonday = (weekday + 5) % 7

        guard let monday = calendar.date(byAdding: .day, value: -daysFromMonday, to: today) else {
            return []
        }

        let weekdayFormatter = DateFormatter()
        weekdayFormatter.locale = Locale(identifier: "de_DE")
        weekdayFormatter.dateFormat = "E"

        let dayFormatter = DateFormatter()
        dayFormatter.locale = Locale(identifier: "de_DE")
        dayFormatter.dateFormat = "dd.MM."

        return (0..<5).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: monday) else {
                return nil
            }

            return WeekdayItem(
                date: date,
                weekdayLabel: weekdayFormatter.string(from: date),
                dayLabel: dayFormatter.string(from: date)
            )
        }
    }
}
