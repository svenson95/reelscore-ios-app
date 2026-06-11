//
//  OverviewWeekdayPickerItem.swift
//  Realscore
//

import Foundation

struct OverviewWeekdayPickerItem: Identifiable {
    let index: Int
    let date: Date

    var id: Int { index }

    var weekdayLabel: String {
        date.weekdayString
    }
}

extension OverviewWeekdayPickerItem {
    static func make(from dates: [Date]) -> [OverviewWeekdayPickerItem] {
        dates.indices
            .filter { index in
                index >= Constants.firstRealWeekdayIndex &&
                index <= Constants.lastRealWeekdayIndex
            }
            .map { index in
                OverviewWeekdayPickerItem(
                    index: index,
                    date: dates[index]
                )
            }
    }
}
