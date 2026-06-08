//
//  WeekdayItem.swift
//  Realscore
//

import Foundation

struct WeekdayItem: Identifiable {
    let id = UUID()
    let date: Date
    
    var weekdayLabel: String {
        date.weekdayString
    }

    var dayLabel: String {
        date.dayMonthString
    }
}
