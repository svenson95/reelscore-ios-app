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

        guard !OverviewSelectionRules.isEdgeIndex(index) else {
            return nil
        }

        return index
    }

    func indexForLoadedDate(
        _ date: Date,
        weekDates: [Date]
    ) -> Int {
        guard let index = OverviewSelectionRules.indexOf(date, in: weekDates) else {
            return Constants.firstRealWeekdayIndex
        }

        guard !OverviewSelectionRules.isEdgeIndex(index) else {
            return Constants.firstRealWeekdayIndex
        }

        return index
    }

    func indexForChangedWeekDates(
        selectedDate: Date,
        tabIndex: Int,
        weekDates: [Date]
    ) -> Int {
        if let matchingIndex = OverviewSelectionRules.indexOf(selectedDate, in: weekDates),
           !OverviewSelectionRules.isEdgeIndex(matchingIndex) {
            return matchingIndex
        }

        return OverviewSelectionRules.safeVisibleIndex(
            tabIndex,
            in: weekDates
        )
    }
}
