//
//  StandingsTableView.swift
//  Realscore
//

import SwiftUI

enum TableConstants {
    static let RANK_COL_WIDTH = 25.0
    static let NUMBER_ROW_WIDTH = 22.0
    static let HSTACK_SPACING = 4.0
}

struct StandingsTableView: View {
    let standings: [StandingRanks]
    let competition: StandingsLeague
    let titleOverride: String?

    private let rowVerticalPadding = 10.0

    init(
        standings: [StandingRanks],
        competition: StandingsLeague,
        titleOverride: String? = nil
    ) {
        self.standings = standings
        self.competition = competition
        self.titleOverride = titleOverride
    }

    var body: some View {
        VStack(spacing: 0) {
            StandingsHeaderView(
                competition: competition,
                titleOverride: titleOverride
            )
            .padding(.vertical, AppLayout.small)
            .padding(.horizontal, AppLayout.small)

            ForEach(standings) { standing in
                Divider()

                StandingsRowView(standing: standing)
                    .padding(.vertical, rowVerticalPadding)
                    .padding(.horizontal, AppLayout.small)
            }
        }
    }
}

private struct StandingsRowView: View {
    let standing: StandingRanks

    private let rankColumnWidth = TableConstants.RANK_COL_WIDTH
    private let numberColumnWidth = TableConstants.NUMBER_ROW_WIDTH
    private let spacing = TableConstants.HSTACK_SPACING

    var body: some View {
        HStack(spacing: spacing) {
            rankView
            teamView

            numberText(standing.all.played)
            numberText(standing.all.win)
            numberText(standing.all.draw)
            numberText(standing.all.lose)

            Text("\(standing.points)")
                .fontWeight(.semibold)
                .frame(width: numberColumnWidth, alignment: .center)
                .monospacedDigit()
        }
        .font(.subheadline)
    }

    private var rankView: some View {
        Text("\(standing.rank)")
            .foregroundStyle(.secondary)
            .frame(width: rankColumnWidth, alignment: .center)
            .monospacedDigit()
    }

    private var teamView: some View {
        HStack(spacing: AppLayout.small) {
            TeamLogoView(teamId: standing.team.id, size: 16)

            Text(standing.team.name.teamName(TeamNameOption.short))
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, AppLayout.small)
    }

    private func numberText(_ value: Int) -> some View {
        Text("\(value)")
            .frame(width: numberColumnWidth, alignment: .center)
            .monospacedDigit()
    }
}

private struct StandingsHeaderView: View {
    let competition: StandingsLeague
    let titleOverride: String?

    private let numberColumnWidth = TableConstants.NUMBER_ROW_WIDTH
    private let spacing = TableConstants.HSTACK_SPACING

    private var title: String {
        titleOverride ?? competition.name
    }

    var body: some View {
        HStack(spacing: spacing) {
            competitionHeaderView
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Sp")
                .frame(width: numberColumnWidth, alignment: .center)

            Text("S")
                .frame(width: numberColumnWidth, alignment: .center)

            Text("U")
                .frame(width: numberColumnWidth, alignment: .center)

            Text("N")
                .frame(width: numberColumnWidth, alignment: .center)

            Text("Pkt")
                .frame(width: numberColumnWidth, alignment: .center)
        }
        .font(.caption)
        .foregroundStyle(.secondary)
    }

    private var competitionHeaderView: some View {
        HStack(spacing: AppLayout.medium) {
            CompetitionLogoView(
                competitionId: competition.id,
                size: 24
            )

            Text(title)
                .lineLimit(1)
                .foregroundStyle(.primary)
                .font(.subheadline)
        }
    }
}
