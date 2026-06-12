//
//  MatchHeaderView.swift
//  Realscore
//

import SwiftUI

struct MatchHeaderView: View {
    let fixture: Fixture

    var body: some View {
        HStack(spacing: 6) {
            Spacer()

            teamSection(for: fixture.teams.home)

            resultColumn

            teamSection(for: fixture.teams.away)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 14)
        .padding(.horizontal, 12)
        .foregroundColor(.primary)
    }

    var teamsString: String {
        fixture.teams.home.name.teamName() + " - " + fixture.teams.away.name.teamName()
    }

    private var resultColumn: some View {
        VStack(spacing: 4) {
            MatchStatusLabelView(fixture: fixture)

            ResultLabelView(
                fixture: fixture,
                showNotPlayedText: true
            )
            .multilineTextAlignment(.center)
        }
        .frame(minWidth: 50)
    }

    private func teamSection(for team: FixtureTeam) -> some View {
        VStack {
            TeamLogoView(teamId: team.id, size: 64)

            Text(team.name.teamName())
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}
