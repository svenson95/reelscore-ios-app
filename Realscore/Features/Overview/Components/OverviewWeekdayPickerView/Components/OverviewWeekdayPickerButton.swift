//
//  OverviewWeekdayPickerButton.swift
//  Realscore
//

import SwiftUI

struct OverviewWeekdayPickerButton: View {
    let item: OverviewWeekdayPickerItem
    let isSelected: Bool
    let width: CGFloat
    let namespace: Namespace.ID
    let onSelect: () -> Void

    var body: some View {
        Button {
            withAnimation(.smooth) {
                onSelect()
            }
        } label: {
            label
                .frame(width: width, height: 44)
        }
        .buttonStyle(.plain)
    }

    private var label: some View {
        Text(item.weekdayLabel)
            .font(.default)
            .fontWeight(.semibold)
            .lineLimit(1)
            .foregroundStyle(isSelected ? Color.accentColor : .primary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(selectionBackground)
            .contentShape(Capsule())
    }

    @ViewBuilder
    private var selectionBackground: some View {
        if isSelected {
            Capsule()
                .fill(Color(uiColor: .secondarySystemFill))
                .matchedGeometryEffect(
                    id: "weekday-selection",
                    in: namespace
                )
        }
    }
}
