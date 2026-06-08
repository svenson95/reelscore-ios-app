//
//  Standings.swift
//  Realscore
//

import Foundation

// MARK: - Standings DTO

public struct StandingsDTO: Codable, Identifiable, Equatable {
    public let id: MongoDbId
    public let league: StandingsLeague
    public let createdAt: Date
    public let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case league
        case createdAt
        case updatedAt
    }
}

// MARK: - Filter

public struct StandingsFilter: Codable, Equatable {
    public let leagueId: CompetitionId
    public let leagueSeason: CompetitionSeason

    enum CodingKeys: String, CodingKey {
        case leagueId = "league.id"
        case leagueSeason = "league.season"
    }
}

// MARK: - Standings League

public struct StandingsLeague: Codable, Equatable {
    public let id: CompetitionId
    public let name: CompetitionName
    public let country: String
    public let logo: String
    public let flag: String?
    public let season: CompetitionSeason
    public let round: CompetitionRound?
    public let standings: [[StandingRanks]]
}

// MARK: - Standing Ranks

public struct StandingRanks: Codable, Equatable, Identifiable {
    public var id: Int {
        rank
    }

    public let rank: Int
    public let team: Team
    public let points: Int
    public let goalsDiff: Int
    public let group: String
    public let form: String?
    public let status: String
    public let description: String?
    public let all: StandingsPlayed
    public let home: StandingsPlayed
    public let away: StandingsPlayed
    public let update: String
}

// MARK: - Played Stats

public struct StandingsPlayed: Codable, Equatable {
    public let played: Int
    public let win: Int
    public let draw: Int
    public let lose: Int
    public let goals: StandingGoals
}

public struct StandingGoals: Codable, Equatable {
    public let `for`: Int
    public let against: Int

    enum CodingKeys: String, CodingKey {
        case `for` = "for"
        case against
    }
}
