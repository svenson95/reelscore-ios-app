//
//  FixtureTeamView.swift
//  Realscore
//

import SwiftUI

struct FixtureTeamView: View {
    let name: String
    let teamId: Int?
    let side: FixtureTeamSide

    var body: some View {
        HStack(spacing: 6) {
            if side == .home {
                teamName(alignment: .trailing)
                logo
            } else {
                logo
                teamName(alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var logo: some View {
        TeamLogoView(teamId: teamId, size: 16)
    }

    private func teamName(alignment: Alignment) -> some View {
        Text(name.teamName(TeamNameOption.short))
            .font(.subheadline)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: alignment)
    }
}

enum FixtureTeamSide {
    case home
    case away
}
