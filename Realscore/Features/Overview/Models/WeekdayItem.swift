//
//  WeekdayItem.swift
//  Realscore
//

import Foundation

struct WeekdayItem: Identifiable, Equatable {
    let date: Date
    let fixtures: [Fixture]

    var id: String {
        date.apiDateString
    }

    var weekdayLabel: String {
        date.weekdayString
    }

    var dayLabel: String {
        date.dayMonthString
    }
}
