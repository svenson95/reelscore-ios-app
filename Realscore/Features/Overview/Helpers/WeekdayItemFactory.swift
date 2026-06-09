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

    static func make(dates: [Date], fixtures: [[Fixture]]) -> [WeekdayItem]? {
        guard dates.count == fixtures.count else {
            return nil
        }

        return zip(dates, fixtures).map {
            WeekdayItem(date: $0, fixtures: $1)
        }
    }
}
