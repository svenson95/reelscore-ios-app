//
//  StandingsRow.swift
//  Realscore
//

import SwiftUI

struct StandingsRowView: View {
    let standing: StandingRanks
    
    let RANK_COL_WIDTH = TableConstants.RANK_COL_WIDTH
    let NUMBER_ROW_WIDTH = TableConstants.NUMBER_ROW_WIDTH
    let HSTACK_SPACING = TableConstants.HSTACK_SPACING

    var body: some View {
        HStack(spacing: HSTACK_SPACING) {
            Text("\(standing.rank).")
                .foregroundStyle(.secondary)
                .frame(width: RANK_COL_WIDTH, alignment: .leading)
                .monospacedDigit()

            HStack(spacing: 8) {
                TeamLogoView(teamId: standing.team.id, size: 16)

                Text(standing.team.name.teamName(TeamNameOption.short))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text("\(standing.all.played)")
                .frame(width: NUMBER_ROW_WIDTH, alignment: .center)
                .monospacedDigit()

            Text("\(standing.all.win)")
                .frame(width: NUMBER_ROW_WIDTH, alignment: .center)
                .monospacedDigit()

            Text("\(standing.all.draw)")
                .frame(width: NUMBER_ROW_WIDTH, alignment: .center)
                .monospacedDigit()

            Text("\(standing.all.lose)")
                .frame(width: NUMBER_ROW_WIDTH, alignment: .center)
                .monospacedDigit()

            Text("\(standing.points)")
                .fontWeight(.semibold)
                .frame(width: NUMBER_ROW_WIDTH, alignment: .center)
                .monospacedDigit()
        }
        .font(.subheadline)
    }
}
