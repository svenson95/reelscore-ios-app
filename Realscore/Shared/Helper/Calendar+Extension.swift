//
//  Calendar+Extension.swift
//  Realscore
//

import Foundation

extension Calendar {
    static var appCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = .appLocale
        calendar.timeZone = .appTimeZone
        calendar.firstWeekday = 2
        return calendar
    }
}
