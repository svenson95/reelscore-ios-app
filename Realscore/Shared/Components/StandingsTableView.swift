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

enum StandingsTableKind {
    case all
    case home
    case away
}

struct StandingsTableView: View {
    let standings: [StandingRanks]
    let competition: StandingsLeague
    let titleOverride: String?
    let tableKind: StandingsTableKind

    private let rowVerticalPadding = 10.0

    init(
        standings: [StandingRanks],
        competition: StandingsLeague,
        titleOverride: String? = nil,
        tableKind: StandingsTableKind = .all
    ) {
        self.standings = standings
        self.competition = competition
        self.titleOverride = titleOverride
        self.tableKind = tableKind
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

                StandingsRowView(
                    standing: standing,
                    tableKind: tableKind
                )
                .padding(.vertical, rowVerticalPadding)
                .padding(.horizontal, AppLayout.small)
            }
        }
    }
}

private struct StandingsRowView: View {
    let standing: StandingRanks
    let tableKind: StandingsTableKind

    private let rankColumnWidth = TableConstants.RANK_COL_WIDTH
    private let numberColumnWidth = TableConstants.NUMBER_ROW_WIDTH
    private let spacing = TableConstants.HSTACK_SPACING

    private var stats: StandingsPlayed {
        switch tableKind {
        case .all:
            standing.all
        case .home:
            standing.home
        case .away:
            standing.away
        }
    }

    private var tableKindPoints: Int {
        (stats.win ?? 0) * 3 + (stats.draw ?? 0)
    }

    var body: some View {
        HStack(spacing: spacing) {
            rankView
            teamView

            numberText(stats.played ?? 0)
            numberText(stats.win ?? 0)
            numberText(stats.draw ?? 0)
            numberText(stats.lose ?? 0)

            Text("\(tableKindPoints)")
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
            TeamLogoView(teamId: standing.team.id, size: .small)

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
