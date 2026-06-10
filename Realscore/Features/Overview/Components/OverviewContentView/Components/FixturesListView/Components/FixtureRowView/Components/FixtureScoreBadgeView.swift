//
//  FixtureScoreBadgeView.swift
//  Realscore
//

import SwiftUI

struct FixtureScoreBadgeView: View {
    let text: String
    let status: FixtureStatusShort

    var body: some View {
        Text(text)
            .font(.subheadline)
            .fontWeight(status.isPlaying ? .bold : .regular)
            .monospacedDigit()
            .frame(minWidth: 28)
            .padding(.horizontal, FixtureRowStyle.badgePaddingHorizontal)
            .padding(.vertical, FixtureRowStyle.badgePaddingVertical)
            .background(background)
    }

    @ViewBuilder
    private var background: some View {
        if status.isFinished {
            RoundedRectangle(cornerRadius: FixtureRowStyle.cornerRadius)
                .fill(FixtureRowStyle.grayBadgeColor)
        }
    }
}
