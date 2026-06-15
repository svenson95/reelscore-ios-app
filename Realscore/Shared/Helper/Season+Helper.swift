//
//  Season+Helper.swift
//  Realscore
//

import Foundation

public enum SeasonHelper {

    private static let multipleGroupsByCompetitionAndSeason:
        [CompetitionId: (CompetitionSeason) -> Bool] = [
            SeasonData.competitionsWithMultipleRoundsInSomeSeasons[0]: {
                season in
                season < 2024
            },
            SeasonData.competitionsWithMultipleRoundsInSomeSeasons[1]: {
                season in
                season < 2024
            },
        ]

    public static func isCompetitionWithMultipleGroups(
        competitionId: CompetitionId,
        season: CompetitionSeason
    ) -> Bool {
        if let seasonSpecificRule = multipleGroupsByCompetitionAndSeason[
            competitionId
        ] {
            return seasonSpecificRule(season)
        }

        return SeasonData.competitionsWithMultipleGroups.contains(competitionId)
    }

    public static func isCompetitionWithoutStandings(
        competitionId: CompetitionId
    ) -> Bool {
        SeasonData.competitionsWithoutStandings.contains(competitionId)
    }

    public static func isCompetitionWithOneFixture(
        competitionId: CompetitionId
    ) -> Bool {
        SeasonData.competitionsWithOnlyOneFixture.contains(competitionId)
    }

    public static func isKoPhase(
        round: CompetitionRound
    ) -> Bool {
        SeasonData.koPhaseRounds.contains(round)
    }

    public static func isCompetitionSeason(
        _ season: Int
    ) -> Bool {
        SeasonData.seasons.contains(season)
    }
}
