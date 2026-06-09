//
//  CompetitionMap.swift
//  Realscore
//

import Foundation

enum CompetitionMap {
    
    static let values: [CompetitionCode: CompetitionData] = [
        // Europa
        .europaUefaChampionsLeague: CompetitionData(
            code: .europaUefaChampionsLeague,
            apiId: 2,
            name: "Champions League",
            url: "champions-league"
        ),
        .europaUefaEuroLeague: CompetitionData(
            code: .europaUefaEuroLeague,
            apiId: 3,
            name: "Europa League",
            url: "euro-league"
        ),
        .europaUefaSuperCup: CompetitionData(
            code: .europaUefaSuperCup,
            apiId: 531,
            name: "UEFA Super Cup",
            url: "uefa-super-cup"
        ),

        // International
        .internationalEuroChampionship: CompetitionData(
            code: .internationalEuroChampionship,
            apiId: 4,
            name: "Europameisterschaft",
            url: "euro-championship"
        ),
        .internationalWorldCup: CompetitionData(
            code: .internationalWorldCup,
            apiId: 1,
            name: "Weltmeisterschaft",
            url: "world-cup"
        ),
        .internationalWorldCupQualificationConcacaf: CompetitionData(
            code: .internationalWorldCupQualificationConcacaf,
            apiId: 31,
            name: "WM - Qualifikation CONCACAF",
            url: "world-cup-qualification-concacaf"
        ),
        .internationalWorldCupQualificationEurope: CompetitionData(
            code: .internationalWorldCupQualificationEurope,
            apiId: 32,
            name: "WM - Qualifikation Europa",
            url: "world-cup-qualification-europe"
        ),
        .internationalUefaNationsLeague: CompetitionData(
            code: .internationalUefaNationsLeague,
            apiId: 5,
            name: "UEFA Nations League",
            url: "nations-league"
        ),
        .internationalFriendlies: CompetitionData(
            code: .internationalFriendlies,
            apiId: 10,
            name: "Freundschaftsspiele",
            url: "friendly-matches"
        ),

        // Deutschland
        .germanyBundesliga: CompetitionData(
            code: .germanyBundesliga,
            apiId: 78,
            name: "Bundesliga",
            url: "bundesliga"
        ),
        .germanyBundesliga2: CompetitionData(
            code: .germanyBundesliga2,
            apiId: 79,
            name: "2. Bundesliga",
            url: "bundesliga-2"
        ),
        .germanySuperCup: CompetitionData(
            code: .germanySuperCup,
            apiId: 529,
            name: "DFL Supercup",
            url: "de-super-cup"
        ),
        .germanyDfbPokal: CompetitionData(
            code: .germanyDfbPokal,
            apiId: 81,
            name: "DFB Pokal",
            url: "dfb-pokal"
        ),

        // England
        .englandPremierLeague: CompetitionData(
            code: .englandPremierLeague,
            apiId: 39,
            name: "Premier League",
            url: "premier-league"
        ),
        .englandLeagueCup: CompetitionData(
            code: .englandLeagueCup,
            apiId: 48,
            name: "Carabao Cup",
            url: "carabao-cup"
        ),
        .englandFaCup: CompetitionData(
            code: .englandFaCup,
            apiId: 45,
            name: "FA Cup",
            url: "fa-cup"
        ),
        .englandCommunityShield: CompetitionData(
            code: .englandCommunityShield,
            apiId: 528,
            name: "Community Shield",
            url: "community-shield"
        ),

        // Spanien
        .spainLaLiga: CompetitionData(
            code: .spainLaLiga,
            apiId: 140,
            name: "La Liga",
            url: "la-liga"
        ),
        .spainSuperCup: CompetitionData(
            code: .spainSuperCup,
            apiId: 556,
            name: "Supercopa",
            url: "es-super-cup"
        ),
        .spainCopaDelRey: CompetitionData(
            code: .spainCopaDelRey,
            apiId: 143,
            name: "Copa del Rey",
            url: "copa-del-rey"
        ),

        // Italien
        .italySerieA: CompetitionData(
            code: .italySerieA,
            apiId: 135,
            name: "Serie A",
            url: "serie-a"
        ),
        .italyCoppaItalia: CompetitionData(
            code: .italyCoppaItalia,
            apiId: 137,
            name: "Coppa Italia",
            url: "coppa-italia"
        ),

        // Frankreich
        .franceLigue1: CompetitionData(
            code: .franceLigue1,
            apiId: 61,
            name: "Ligue 1",
            url: "ligue-1"
        ),
        .franceCoupeDeFrance: CompetitionData(
            code: .franceCoupeDeFrance,
            apiId: 66,
            name: "Coupe de France",
            url: "coupe-de-france"
        ),
        .franceTropheeDesChampions: CompetitionData(
            code: .franceTropheeDesChampions,
            apiId: 526,
            name: "Trophée des Champions",
            url: "trophee-des-champions"
        ),

        // Niederlande
        .eredivisie: CompetitionData(
            code: .eredivisie,
            apiId: 88,
            name: "Eredivisie",
            url: "eredivisie"
        ),

        // USA
        .majorLeagueSoccer: CompetitionData(
            code: .majorLeagueSoccer,
            apiId: 253,
            name: "Major League Soccer",
            url: "mls"
        )
    ]

    static var all: [CompetitionData] {
        CompetitionCode.allCases.compactMap { values[$0] }
    }

    static func competition(for code: CompetitionCode) -> CompetitionData? {
        values[code]
    }

    static func competition(forApiId apiId: CompetitionId) -> CompetitionData? {
        values.values.first { $0.apiId == apiId }
    }

    static func name(for code: CompetitionCode) -> CompetitionName {
        values[code]?.name ?? code.rawValue
    }

    static func url(for code: CompetitionCode) -> CompetitionUrl? {
        values[code]?.url
    }

    static func apiId(for code: CompetitionCode) -> CompetitionId? {
        values[code]?.apiId
    }
}

extension CompetitionMap {
    
    static func required(_ code: CompetitionCode) -> CompetitionData {
        guard let competition = values[code] else {
            preconditionFailure("Missing competition mapping for \(code.rawValue)")
        }

        return competition
    }

    static func asCompetition(_ code: CompetitionCode) -> Competition {
        return Competition(
            id: code.apiId,
            name: code.name,
            type: type(for: code),
            logo: nil,
            country: country(for: code),
            season: nil
        )
    }

    nonisolated private static func type(for code: CompetitionCode) -> String {
        switch code {
        case .germanyBundesliga,
             .germanyBundesliga2,
             .englandPremierLeague,
             .spainLaLiga,
             .italySerieA,
             .franceLigue1,
             .eredivisie,
             .majorLeagueSoccer:
            "League"

        default:
            "Cup"
        }
    }

    nonisolated private static func country(for code: CompetitionCode) -> String {
        switch code {
        case .europaUefaChampionsLeague,
             .europaUefaEuroLeague,
             .europaUefaSuperCup:
            "Europa"

        case .internationalEuroChampionship,
             .internationalWorldCup,
             .internationalWorldCupQualificationConcacaf,
             .internationalWorldCupQualificationEurope,
             .internationalUefaNationsLeague,
             .internationalFriendlies:
            "International"

        case .germanyBundesliga,
             .germanyBundesliga2,
             .germanySuperCup,
             .germanyDfbPokal:
            "Deutschland"

        case .englandPremierLeague,
             .englandLeagueCup,
             .englandFaCup,
             .englandCommunityShield:
            "England"

        case .spainLaLiga,
             .spainSuperCup,
             .spainCopaDelRey:
            "Spanien"

        case .italySerieA,
             .italyCoppaItalia:
            "Italien"

        case .franceLigue1,
             .franceCoupeDeFrance,
             .franceTropheeDesChampions:
            "Frankreich"

        case .eredivisie:
            "Niederlande"

        case .majorLeagueSoccer:
            "USA"
        }
    }
}
