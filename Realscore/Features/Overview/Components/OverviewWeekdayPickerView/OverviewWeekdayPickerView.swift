//
//  OverviewWeekdayPickerView.swift
//  Realscore
//

import SwiftUI

struct OverviewWeekdayPickerView: View {
    let weekDates: [Date]

    @Binding var selectedDayIndex: Int

    @Namespace private var glassNamespace
    @Namespace private var selectionNamespace

    private var items: [OverviewWeekdayPickerItem] {
        OverviewWeekdayPickerItem.make(from: weekDates)
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
        let itemWidth = OverviewWeekdayPickerLayout.itemWidth(
            containerWidth: width,
            itemCount: items.count
        )

        return HStack(spacing: OverviewWeekdayPickerLayout.spacing) {
            ForEach(items) { item in
                OverviewWeekdayPickerButton(
                    item: item,
                    isSelected: item.index == selectedDayIndex,
                    width: itemWidth,
                    namespace: selectionNamespace,
                    onSelect: {
                        selectedDayIndex = item.index
                    }
                )
                .padding(OverviewWeekdayPickerLayout.outerPadding)
                .glassEffect(.regular.interactive(), in: .capsule)
                .glassEffectUnion(
                    id: "weekday-picker",
                    namespace: glassNamespace
                )
            }
        }
    }
}
