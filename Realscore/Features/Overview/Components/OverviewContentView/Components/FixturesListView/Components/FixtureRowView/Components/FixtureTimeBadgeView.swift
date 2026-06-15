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
            .frame(width: 42, alignment: .center)
            .padding(.horizontal, AppLayout.badgePaddingHorizontal)
            .padding(.vertical, AppLayout.badgePaddingVertical)
            .background(AppColors.badgeBackground(status: status))
            .cornerRadius(AppLayout.cornerRadiusSmall)
            .font(.caption)
            .fontWeight(status.isPlaying ? .semibold : .regular)
            .foregroundStyle(AppColors.badgeText(status: status))
            .strikethrough(status.isEnded)
            .monospacedDigit()
    }
}
