//
//  MatchStatsView.swift
//  Realscore
//

import SwiftUI

struct MatchStatsView: View {
    let fixture: Fixture

    var body: some View {
        Section("Stats") {
            LabeledContent("Fixture ID", value: "\(fixture.id)")
            LabeledContent("Start", value: fixture.fixture.date)
            LabeledContent("Status", value: fixture.fixture.status.long)

            if let elapsed = fixture.fixture.status.elapsed {
                LabeledContent("Minute", value: "\(elapsed)")
            }

            LabeledContent("League", value: fixture.league.name.competitionName())
            LabeledContent("Teams", value: fixture.displayName)
        }
    }
}
