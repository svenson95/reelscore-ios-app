//
//  RoundMapRules.swift
//  Realscore
//

import Foundation

enum RoundMapRules {
    static let values: [RoundMapRule] = [
        RoundMapRule(
            id: CompetitionCode.europaUefaChampionsLeague.apiId,
            fromSeason: 2025,
            map: ChampionsLeagueFrom2025RoundMap.values
        ),

        RoundMapRule(
            id: CompetitionCode.germanyBundesliga.apiId,
            fromSeason: Constants.firstSupportedSeason,
            map: LeagueRelegationRoundMap.values
        ),

        RoundMapRule(
            id: CompetitionCode.germanyBundesliga2.apiId,
            fromSeason: Constants.firstSupportedSeason,
            map: LeagueRelegationRoundMap.values
        ),

        RoundMapRule(
            id: CompetitionCode.italySerieA.apiId,
            fromSeason: Constants.firstSupportedSeason,
            map: LeagueRelegationRoundMap.values
        ),

        RoundMapRule(
            id: CompetitionCode.franceLigue1.apiId,
            fromSeason: Constants.firstSupportedSeason,
            map: LeagueRelegationRoundMap.values
        ),

        RoundMapRule(
            id: CompetitionCode.spainLaLiga.apiId,
            fromSeason: Constants.firstSupportedSeason,
            map: LeagueRelegationRoundMap.values
        ),

        RoundMapRule(
            id: CompetitionCode.englandPremierLeague.apiId,
            fromSeason: Constants.firstSupportedSeason,
            map: LeagueRelegationRoundMap.values
        )
    ]
}
