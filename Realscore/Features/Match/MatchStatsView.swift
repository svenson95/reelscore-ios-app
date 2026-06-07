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
            LabeledContent("Mongo ID", value: fixture.mongoId)
            LabeledContent("Start", value: fixture.fixture.date)
            LabeledContent("Status", value: fixture.fixture.status.short)

            if let elapsed = fixture.fixture.status.elapsed {
                LabeledContent("Minute", value: "\(elapsed)")
            }

            LabeledContent("League", value: fixture.league.name)
            LabeledContent("Teams", value: fixture.displayName)
        }
    }
}
