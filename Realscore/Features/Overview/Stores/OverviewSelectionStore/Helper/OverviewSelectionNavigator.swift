//
//  OverviewSelectionNavigator.swift
//  Realscore
//

import Foundation

struct OverviewSelectionNavigator {
    func indexForVisibleDate(
        _ date: Date,
        weekDates: [Date]
    ) -> Int? {
        guard let index = OverviewSelectionRules.indexOf(date, in: weekDates) else {
            return nil
        }

        return OverviewSelectionRules.realWeekdayIndex(for: index)
    }

    func indexForLoadedDate(
        _ date: Date,
        weekDates: [Date]
    ) -> Int {
        guard let index = OverviewSelectionRules.indexOf(date, in: weekDates) else {
            return Constants.firstRealWeekdayIndex
        }

        return OverviewSelectionRules.realWeekdayIndex(for: index)
    }

    func indexForChangedWeekDates(
        selectedDate: Date,
        tabIndex: Int,
        weekDates: [Date]
    ) -> Int {
        if let matchingIndex = OverviewSelectionRules.indexOf(selectedDate, in: weekDates) {
            return matchingIndex
        }

        return OverviewSelectionRules.safeIndex(
            tabIndex,
            in: weekDates
        )
    }
}
