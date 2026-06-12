//
//  MatchDetails.swift
//  Realscore
//

import SwiftUI

struct MatchDetails: View {
    let fixture: Fixture

    var body: some View {
        Group {
            LabeledContent("Fixture ID", value: "\(fixture.id)")
            LabeledContent("Start", value: fixture.fixture.date)
            LabeledContent("Status", value: fixture.fixture.status.long)
            
            if let elapsed = fixture.fixture.status.elapsed {
                LabeledContent("Minute", value: "\(elapsed)")
            }
            
            LabeledContent("League", value: fixture.league.name.competitionName())
            let home = fixture.teams.home.name.teamName();
            let away = fixture.teams.away.name.teamName();
            LabeledContent("Teams", value: home + " vs " + away)
        }
        
        Group {
            LabeledContent("Fixture ID", value: "\(fixture.id)")
            LabeledContent("Start", value: fixture.fixture.date)
            LabeledContent("Status", value: fixture.fixture.status.long)
            
            if let elapsed = fixture.fixture.status.elapsed {
                LabeledContent("Minute", value: "\(elapsed)")
            }
            
            LabeledContent("League", value: fixture.league.name.competitionName())
            let home = fixture.teams.home.name.teamName();
            let away = fixture.teams.away.name.teamName();
            LabeledContent("Teams", value: home + " vs " + away)
        }
        
        Group {
            LabeledContent("Fixture ID", value: "\(fixture.id)")
            LabeledContent("Start", value: fixture.fixture.date)
            LabeledContent("Status", value: fixture.fixture.status.long)
            
            if let elapsed = fixture.fixture.status.elapsed {
                LabeledContent("Minute", value: "\(elapsed)")
            }
            
            LabeledContent("League", value: fixture.league.name.competitionName())
            let home = fixture.teams.home.name.teamName();
            let away = fixture.teams.away.name.teamName();
            LabeledContent("Teams", value: home + " vs " + away)
        }
    }
}
