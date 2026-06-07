//
//  FixtureRowView.swift
//  Realscore
//

import SwiftUI

struct FixtureRowView: View {
    let fixture: Fixture

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(fixture.displayName)
                    .font(.headline)

                Text(fixture.league.name)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(scoreText)
                .font(.headline)
        }
    }

    private var scoreText: String {
        let home = fixture.goals.home.map(String.init) ?? "-"
        let away = fixture.goals.away.map(String.init) ?? "-"
        return "\(home):\(away)"
    }
}
