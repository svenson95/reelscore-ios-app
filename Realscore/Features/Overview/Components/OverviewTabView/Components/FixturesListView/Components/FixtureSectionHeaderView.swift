//
//  FixtureSectionHeaderView.swift
//  Realscore
//

import SwiftUI

struct FixtureSectionHeaderView: View {
    let group: FixtureSectionGroup

    var body: some View {
        HStack(spacing: 12) {
            CompetitionLogoView(
                competitionId: group.competitionId,
                size: FixtureSectionHeaderStyle.logoSize
            )

            Text(group.competition)
                .font(.default)
                .fontWeight(.semibold)
                .lineLimit(1)

            Spacer()

            Text(group.round)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .textCase(nil)
    }
}

private enum FixtureSectionHeaderStyle {
    static let logoSize: CGFloat = 14
}
