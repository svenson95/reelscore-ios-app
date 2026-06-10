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
                size: 24
            )
            
            Text(group.competition)
                .lineLimit(1)

            Spacer()

            Text(group.round)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(.vertical, 4)
    }
}
