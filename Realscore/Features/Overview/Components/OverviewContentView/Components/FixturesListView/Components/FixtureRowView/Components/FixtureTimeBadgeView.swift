//
//  FixtureTimeBadgeView.swift
//  Realscore
//

import SwiftUI

struct FixtureTimeBadgeView: View {
    let text: String
    let status: FixtureStatusShort

    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(status.isPlaying ? .semibold : .regular)
            .foregroundStyle(textColor)
            .strikethrough(status.isEnded)
            .monospacedDigit()
            .frame(width: 42, alignment: .center)
            .padding(.horizontal, FixtureRowStyle.badgePaddingHorizontal)
            .padding(.vertical, FixtureRowStyle.badgePaddingVertical)
            .background(background)
    }

    private var textColor: Color {
        if status.isPlaying {
            return Color(.systemBackground)
        }

        if status.isEnded {
            return .secondary
        }

        return .primary
    }

    @ViewBuilder
    private var background: some View {
        if status.isPlaying {
            RoundedRectangle(cornerRadius: AppLayout.cornerRadiusSmall)
                .fill(.green)
        }

        if status.isScheduled {
            RoundedRectangle(cornerRadius: AppLayout.cornerRadiusSmall)
                .fill(FixtureRowStyle.grayBadgeColor)
        }
    }
}
