//
//  FixtureGrouping.swift
//  Realscore
//

import Foundation

extension Array where Element == Fixture {
    func groupedByCompetitionAndRound() -> [FixtureSectionGroup] {
        let groups = Dictionary(grouping: self) { fixture in
            FixtureGroupKey(
                competition: fixture.league.name,
                round: fixture.league.round ?? "-"
            )
        }

        return groups
            .map { key, fixtures in
                FixtureSectionGroup(
                    competition: key.competition,
                    competitionLogo: fixtures.first?.league.logo,
                    round: key.round,
                    fixtures: fixtures
                )
            }
            .sorted {
                if $0.competition == $1.competition {
                    return $0.round < $1.round
                }

                return $0.competition < $1.competition
            }
    }
}
