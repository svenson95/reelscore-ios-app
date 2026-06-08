//
//  OverviewWeekdayPickerView.swift
//  Realscore
//

import SwiftUI

struct OverviewWeekdayPickerView: View {
    let weekDates: [Date]

    @Binding var selectedDayIndex: Int

    private let firstRealDayIndex = Constants.firstRealWeekdayIndex
    private let lastRealDayIndex = Constants.lastRealWeekdayIndex

    var body: some View {
        HStack(spacing: 4) {
            ForEach(weekdayItems) { item in
                Button {
                    selectedDayIndex = item.index
                } label: {
                    weekdayContent(for: item)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(.bar)
    }

    private var weekdayItems: [OverviewWeekdayPickerItem] {
        weekDates.indices
            .filter { index in
                index >= firstRealDayIndex && index <= lastRealDayIndex
            }
            .map { index in
                OverviewWeekdayPickerItem(
                    index: index,
                    date: weekDates[index]
                )
            }
    }

    private func weekdayContent(for item: OverviewWeekdayPickerItem) -> some View {
        VStack(spacing: 3) {
            Text(item.weekdayLabel)
                .font(.caption2)
                .fontWeight(.semibold)
                .lineLimit(1)

            Text(item.dayLabel)
                .font(.caption2)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(backgroundColor(for: item))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func backgroundColor(for item: OverviewWeekdayPickerItem) -> Color {
        selectedDayIndex == item.index
            ? Color.gray.opacity(0.1)
            : Color.clear
    }
}

private struct OverviewWeekdayPickerItem: Identifiable {
    let index: Int
    let date: Date

    var id: Int {
        index
    }

    var weekdayLabel: String {
        date.weekdayString
    }

    var dayLabel: String {
        date.dayMonthString
    }
}
