//
//  StaticCompetitionData.swift
//  Realscore
//

import Foundation

struct SelectCompetitionGroup: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let competitions: [Competition]
}

private struct SelectCompetitionGroupDefinition {
    let title: String
    let competitions: [CompetitionCode]

    func makeGroup() -> SelectCompetitionGroup {
        SelectCompetitionGroup(
            title: title,
            competitions: competitions.map { CompetitionMap.asCompetition($0) }
        )
    }
}

enum StaticCompetitionData {

    private static let definitions: [SelectCompetitionGroupDefinition] = [
        SelectCompetitionGroupDefinition(title: "Europa", competitions: [
            .europaUefaChampionsLeague,
            .europaUefaEuroLeague,
            .germanyBundesliga,
            .englandPremierLeague,
            .spainLaLiga,
            .italySerieA,
            .franceLigue1,
            .eredivisie
        ]),

        SelectCompetitionGroupDefinition(title: "Deutschland", competitions: [
            .germanyBundesliga2,
            .germanySuperCup,
            .germanyDfbPokal
        ]),

        SelectCompetitionGroupDefinition(title: "England", competitions: [
            .englandLeagueCup,
            .englandFaCup,
            .englandCommunityShield
        ]),

        SelectCompetitionGroupDefinition(title: "Spanien", competitions: [
            .spainSuperCup,
            .spainCopaDelRey
        ]),

        SelectCompetitionGroupDefinition(title: "Italien", competitions: [
            .italyCoppaItalia
        ]),

        SelectCompetitionGroupDefinition(title: "Frankreich", competitions: [
            .franceCoupeDeFrance,
            .franceTropheeDesChampions
        ]),

        SelectCompetitionGroupDefinition(title: "USA", competitions: [
            .majorLeagueSoccer
        ]),

        SelectCompetitionGroupDefinition(title: "Andere", competitions: [
            .europaUefaSuperCup
        ]),

        SelectCompetitionGroupDefinition(title: "International", competitions: [
            .internationalWorldCup,
            .internationalWorldCupQualificationConcacaf,
            .internationalWorldCupQualificationEurope,
            .internationalUefaNationsLeague,
            .internationalEuroChampionship,
            .internationalFriendlies
        ])
    ]

    static let groups: [SelectCompetitionGroup] = definitions.map {
        $0.makeGroup()
    }

    static var flat: [Competition] {
        groups.flatMap(\.competitions)
    }
}
