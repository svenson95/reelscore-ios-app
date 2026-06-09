//
//  OverviewWeekdayPickerLayout.swift
//  Realscore
//

import Foundation

enum OverviewWeekdayPickerLayout {
    static let spacing: CGFloat = 0
    static let outerPadding: CGFloat = 4
    static let height: CGFloat = 52
    static let buttonHeight: CGFloat = 44
    static let horizontalPadding: CGFloat = 16
    static let bottomPadding: CGFloat = 16

    static func itemWidth(
        containerWidth: CGFloat,
        itemCount: Int
    ) -> CGFloat {
        let count = max(CGFloat(itemCount), 1)
        let totalSpacing = spacing * max(count - 1, 0)
        let totalPadding = outerPadding * 2 * count
        let availableWidth = max(containerWidth - totalSpacing - totalPadding, 0)

        return availableWidth / count
    }
}
