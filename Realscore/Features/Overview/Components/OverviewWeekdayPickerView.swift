//
//  OverviewWeekdayPickerView.swift
//  Realscore
//

import SwiftUI

struct OverviewWeekdayPickerItem: Identifiable {
    let index: Int
    let weekdayLabel: String
    let dayLabel: String

    var id: Int {
        index
    }
}

struct OverviewWeekdayPickerView: View {
    let items: [OverviewWeekdayPickerItem]

    @Binding var selectedDayIndex: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(items) { item in
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
            ? Color.accentColor.opacity(0.18)
            : Color.clear
    }
}
