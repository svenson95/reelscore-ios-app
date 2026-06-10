//
//  FixtureRowView.swift
//  Realscore
//

import SwiftUI

struct FixtureRowView: View {
    let fixture: Fixture

    private var status: FixtureStatusShort {
        fixture.fixture.status.short
    }

    private var timeText: String {
        FixtureRowTextProvider.time(for: fixture)
    }

    private var scoreText: String {
        FixtureRowTextProvider.score(for: fixture)
    }

    var body: some View {
        HStack(spacing: 6) {
            FixtureTimeBadgeView(
                text: timeText,
                status: status
            )

            HStack(spacing: 6) {
                FixtureTeamView(
                    name: fixture.teams.home.name,
                    teamId: fixture.teams.home.id,
                    side: .home
                )

                FixtureScoreBadgeView(
                    text: scoreText,
                    status: status
                )

                FixtureTeamView(
                    name: fixture.teams.away.name,
                    teamId: fixture.teams.away.id,
                    side: .away
                )
            }
        }
    }
}
