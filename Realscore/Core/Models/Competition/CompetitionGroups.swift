//
//  CompetitionGroups.swift
//  Realscore
//

import Foundation

enum CompetitionGroups {

    static let values: [CompetitionGroup] = [
        CompetitionGroup(
            title: "Europa",
            competitions: [
                .required(.europaUefaChampionsLeague),
                .required(.europaUefaEuroLeague),
                .required(.europaUefaSuperCup)
            ]
        ),
        CompetitionGroup(
            title: "International",
            competitions: [
                .required(.internationalEuroChampionship),
                .required(.internationalWorldCup),
                .required(.internationalWorldCupQualificationConcacaf),
                .required(.internationalWorldCupQualificationEurope),
                .required(.internationalUefaNationsLeague),
                .required(.internationalFriendlies)
            ]
        ),
        CompetitionGroup(
            title: "Deutschland",
            competitions: [
                .required(.germanyBundesliga),
                .required(.germanyBundesliga2),
                .required(.germanySuperCup),
                .required(.germanyDfbPokal)
            ]
        ),
        CompetitionGroup(
            title: "England",
            competitions: [
                .required(.englandPremierLeague),
                .required(.englandLeagueCup),
                .required(.englandFaCup),
                .required(.englandCommunityShield)
            ]
        ),
        CompetitionGroup(
            title: "Spanien",
            competitions: [
                .required(.spainLaLiga),
                .required(.spainSuperCup),
                .required(.spainCopaDelRey)
            ]
        ),
        CompetitionGroup(
            title: "Italien",
            competitions: [
                .required(.italySerieA),
                .required(.italyCoppaItalia)
            ]
        ),
        CompetitionGroup(
            title: "Frankreich",
            competitions: [
                .required(.franceLigue1),
                .required(.franceCoupeDeFrance),
                .required(.franceTropheeDesChampions)
            ]
        ),
        CompetitionGroup(
            title: "Niederlande",
            competitions: [
                .required(.eredivisie)
            ]
        ),
        CompetitionGroup(
            title: "USA",
            competitions: [
                .required(.majorLeagueSoccer)
            ]
        )
    ]
}

private extension CompetitionData {
    static func required(_ code: CompetitionCode) -> CompetitionData {
        guard let competition = CompetitionMap.competition(for: code) else {
            preconditionFailure("Missing competition mapping for \(code.rawValue)")
        }

        return competition
    }
}
