//
//  CompetitionRowView.swift
//  Realscore
//

import SwiftUI

struct CompetitionRowView: View {
    let competition: Competition

    var body: some View {
        HStack(spacing: 12) {
            CompetitionLogoView(
                competitionId: competition.id,
                size: 14
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(competition.name)
                    .font(.headline)

                if let country = competition.country {
                    Text(country)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
