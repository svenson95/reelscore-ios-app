//
//  StaticCompetitionData.swift
//  Realscore
//

import Foundation

struct CompetitionGroup: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let competitions: [Competition]
}

enum StaticCompetitionData {
    static let groups: [CompetitionGroup] = [
        CompetitionGroup(title: "Europa", competitions: [
            Competition(id: 2, name: "UEFA Champions League", type: "Cup", logo: nil, country: "Europa", season: nil),
            Competition(id: 3, name: "UEFA Europa League", type: "Cup", logo: nil, country: "Europa", season: nil),
            Competition(id: 78, name: "Bundesliga", type: "League", logo: nil, country: "Deutschland", season: nil),
            Competition(id: 39, name: "Premier League", type: "League", logo: nil, country: "England", season: nil),
            Competition(id: 140, name: "La Liga", type: "League", logo: nil, country: "Spanien", season: nil),
            Competition(id: 135, name: "Serie A", type: "League", logo: nil, country: "Italien", season: nil),
            Competition(id: 61, name: "Ligue 1", type: "League", logo: nil, country: "Frankreich", season: nil),
            Competition(id: 88, name: "Eredivisie", type: "League", logo: nil, country: "Niederlande", season: nil)
        ]),

        CompetitionGroup(title: "Deutschland", competitions: [
            Competition(id: 79, name: "2. Bundesliga", type: "League", logo: nil, country: "Deutschland", season: nil),
            Competition(id: 529, name: "Super Cup", type: "Cup", logo: nil, country: "Deutschland", season: nil),
            Competition(id: 81, name: "DFB Pokal", type: "Cup", logo: nil, country: "Deutschland", season: nil)
        ]),

        CompetitionGroup(title: "England", competitions: [
            Competition(id: 48, name: "League Cup", type: "Cup", logo: nil, country: "England", season: nil),
            Competition(id: 45, name: "FA Cup", type: "Cup", logo: nil, country: "England", season: nil),
            Competition(id: 528, name: "Community Shield", type: "Cup", logo: nil, country: "England", season: nil)
        ]),

        CompetitionGroup(title: "Spanien", competitions: [
            Competition(id: 556, name: "Super Cup", type: "Cup", logo: nil, country: "Spanien", season: nil),
            Competition(id: 143, name: "Copa del Rey", type: "Cup", logo: nil, country: "Spanien", season: nil)
        ]),

        CompetitionGroup(title: "Italien", competitions: [
            Competition(id: 137, name: "Coppa Italia", type: "Cup", logo: nil, country: "Italien", season: nil)
        ]),

        CompetitionGroup(title: "Frankreich", competitions: [
            Competition(id: 66, name: "Coupe de France", type: "Cup", logo: nil, country: "Frankreich", season: nil),
            Competition(id: 526, name: "Trophée des Champions", type: "Cup", logo: nil, country: "Frankreich", season: nil)
        ]),

        CompetitionGroup(title: "USA", competitions: [
            Competition(id: 253, name: "Major League Soccer", type: "League", logo: nil, country: "USA", season: nil)
        ]),

        CompetitionGroup(title: "Andere", competitions: [
            Competition(id: 531, name: "UEFA Super Cup", type: "Cup", logo: nil, country: "Europa", season: nil)
        ]),

        CompetitionGroup(title: "International", competitions: [
            Competition(id: 1, name: "World Cup", type: "Cup", logo: nil, country: "International", season: nil),
            Competition(id: 31, name: "World Cup Qualification CONCACAF", type: "Cup", logo: nil, country: "International", season: nil),
            Competition(id: 32, name: "World Cup Qualification Europe", type: "Cup", logo: nil, country: "International", season: nil),
            Competition(id: 5, name: "UEFA Nations League", type: "Cup", logo: nil, country: "International", season: nil),
            Competition(id: 4, name: "Euro Championship", type: "Cup", logo: nil, country: "International", season: nil),
            Competition(id: 10, name: "Friendlies", type: "Cup", logo: nil, country: "International", season: nil)
        ])
    ]

    static var flat: [Competition] {
        groups.flatMap(\.competitions)
    }
}
