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

    func switchWeek(
        from edgeIndex: Int,
        fallbackIndex: Int,
        loadPreviousWeek: () async -> Bool,
        loadNextWeek: () async -> Bool
    ) async -> OverviewWeekSwitchResult {
        switch edgeIndex {
        case Constants.previousWeekEdgeIndex:
            let didLoad = await loadPreviousWeek()

            return OverviewWeekSwitchResult(
                didLoad: didLoad,
                targetIndex: didLoad
                    ? Constants.lastRealWeekdayIndex
                    : fallbackIndex
            )

        case Constants.nextWeekEdgeIndex:
            let didLoad = await loadNextWeek()

            return OverviewWeekSwitchResult(
                didLoad: didLoad,
                targetIndex: didLoad
                    ? Constants.firstRealWeekdayIndex
                    : fallbackIndex
            )

        default:
            return OverviewWeekSwitchResult(
                didLoad: false,
                targetIndex: fallbackIndex
            )
        }
    }
}

struct OverviewWeekSwitchResult {
    let didLoad: Bool
    let targetIndex: Int
}
