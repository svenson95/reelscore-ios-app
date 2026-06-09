//
//  WeekdayHelper.swift
//  Realscore
//

import Foundation

enum WeekdayHelper {
    static func currentWorkWeek() -> [WeekdayItem] {
        let calendar = Calendar.current
        let today = Date()
        let daysFromMonday = today.weekdayIndex

        guard let monday = calendar.date(byAdding: .day, value: -daysFromMonday, to: today) else {
            return []
        }

        var items: [WeekdayItem] = []

        for offset in 0..<5 {
            guard let date = calendar.date(byAdding: .day, value: offset, to: monday) else {
                continue
            }

            items.append(WeekdayItem(date: date, fixtures: []))
        }

        return items
    }
}
