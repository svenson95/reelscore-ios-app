//
//  OverviewWeekdayPickerView.swift
//  Realscore
//

import SwiftUI

struct OverviewWeekdayPickerView: View {
    let weekDates: [Date]
    let selectedIndex: Int
    let tabProgress: CGFloat?
    let onSelectIndex: (Int) -> Void
    
    @Environment(\.colorScheme) private var scheme

    init(
        weekDates: [Date],
        selectedIndex: Int,
        tabProgress: CGFloat? = nil,
        onSelectIndex: @escaping (Int) -> Void
    ) {
        self.weekDates = weekDates
        self.selectedIndex = selectedIndex
        self.tabProgress = tabProgress
        self.onSelectIndex = onSelectIndex
    }

    private var resolvedTabProgress: CGFloat {
        if let tabProgress {
            return tabProgress
        }

        guard weekDates.count > 1 else { return 0 }

        let safeIndex = min(
            max(selectedIndex, 0),
            weekDates.count - 1
        )

        return CGFloat(safeIndex) / CGFloat(weekDates.count - 1)
    }

    var body: some View {
        GlassEffectContainer {
            GeometryReader { proxy in
                pickerContent(width: proxy.size.width)
            }
            .frame(height: OverviewWeekdayPickerLayout.height)
            .padding(.horizontal, OverviewWeekdayPickerLayout.horizontalPadding)
            .padding(.bottom, OverviewWeekdayPickerLayout.bottomPadding)
        }
    }

    private func pickerContent(width: CGFloat) -> some View {
        HStack(spacing: 0) {
            ForEach(weekDates.indices, id: \.self) { index in
                tabItem(
                    date: weekDates[index],
                    index: index
                )
            }
        }
        .weekdayTabMask(
            resolvedTabProgress,
            tabCount: weekDates.count
        )
        .background {
            movingSelectionCapsule(width: width)
        }
        .background(
            scheme == .dark ? Color(.secondarySystemGroupedBackground) : Color(.systemBackground)
            , in: .capsule
        )
        .clipShape(Capsule())
        .glassEffect(.regular, in: .capsule)
    }

    private func movingSelectionCapsule(width: CGFloat) -> some View {
        let capsuleWidth = capsuleWidth(totalWidth: width)
        let travelDistance = max(width - capsuleWidth, 0)

        return Capsule()
            .fill(scheme == .dark ?
                  Color(.tertiarySystemGroupedBackground) : Color(.systemGroupedBackground)
            )
            .frame(width: capsuleWidth)
            .offset(
                x: resolvedTabProgress * travelDistance - travelDistance / 2
            )
    }

    private func tabItem(date: Date, index: Int) -> some View {
        VStack(spacing: 4) {
            Text(date.weekdayString)
        }
        .frame(maxWidth: .infinity, minHeight: 30)
        .padding(.vertical, 10)
        .contentShape(.capsule)
        .onTapGesture {
            onSelectIndex(index)
        }
    }

    private func capsuleWidth(totalWidth: CGFloat) -> CGFloat {
        guard !weekDates.isEmpty else { return 0 }

        return totalWidth / CGFloat(weekDates.count)
    }
}
