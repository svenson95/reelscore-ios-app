//
//  SearchResult+Display.swift
//  Realscore
//

import Foundation

extension SearchResult {
    var title: String {
        switch self {
        case .fixture(let result):
            let homeName = result.data.teams.home.name
            let awayName = result.data.teams.away.name

            return [
                homeName.transformedTeamName,
                awayName.transformedTeamName
            ]
            .filter { !$0.isEmpty }
            .joined(separator: " - ")

        case .competition(let result):
            return result.data.league.name

        case .team(let result):
            return (result.data.team.name).transformedTeamName
        }
    }

    var subtitle: String {
        switch self {
        case .fixture(let result):
            return result.data.league.name

        case .competition(let result):
            return result.data.league.country ?? ""

        case .team:
            return ""
        }
    }

    var season: String {
        switch self {
        case .fixture(let result):
            guard let season = result.data.league.season else {
                return ""
            }

            let shortSeason = season % 100
            let nextShortSeason = (shortSeason + 1) % 100

            return String(format: "%02d/%02d", shortSeason, nextShortSeason)

        case .competition, .team:
            return ""
        }
    }
}
