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
                round: fixture.league.round ?? ""
            )
        }

        return groups
            .map { key, fixtures in
                FixtureSectionGroup(
                    competition: key.competition.competitionName(),
                    competitionLogo: fixtures.first!.league.logo,
                    competitionId: fixtures.first!.league.id,
                    round: key.round.roundLabel(
                        competitionId: fixtures.first!.league.id,
                        season: fixtures.first!.league.season!,
                        option: RoundLabelType.header
                    ),
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
