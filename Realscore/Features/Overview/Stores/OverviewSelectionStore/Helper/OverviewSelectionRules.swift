//
//  OverviewSelectionRules.swift
//  Realscore
//

import Foundation

enum OverviewSelectionRules {
    static func indexOf(
        _ date: Date,
        in weekDates: [Date]
    ) -> Int? {
        weekDates.firstIndex {
            Calendar.appCalendar.isDate($0, inSameDayAs: date)
        }
    }

    static func safeInitialIndex(
        todayWeekdayIndex: Int,
        weekDates: [Date]
    ) -> Int {
        weekDates.indices.contains(todayWeekdayIndex)
            ? todayWeekdayIndex
            : Constants.firstRealWeekdayIndex
    }

    static func safeIndex(
        _ index: Int,
        in weekDates: [Date]
    ) -> Int {
        weekDates.indices.contains(index)
            ? index
            : Constants.firstRealWeekdayIndex
    }

    static func realWeekdayIndex(for index: Int) -> Int {
        isEdgeIndex(index)
            ? Constants.firstRealWeekdayIndex
            : index
    }

    static func isEdgeIndex(_ index: Int) -> Bool {
        index == Constants.previousWeekEdgeIndex ||
        index == Constants.nextWeekEdgeIndex
    }
}
