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
            .foregroundStyle(AppColors.timeText(status: status))
            .background {
                RoundedRectangle(cornerRadius: AppLayout.cornerRadiusSmall)
                    .fill(AppColors.timeBackground(status: status))
            }
            .strikethrough(status.isEnded)
            .monospacedDigit()
            .frame(width: 42, alignment: .center)
            .padding(.horizontal, FixtureRowStyle.badgePaddingHorizontal)
            .padding(.vertical, FixtureRowStyle.badgePaddingVertical)
    }
}
