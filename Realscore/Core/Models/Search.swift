//
//  Search.swift
//  Realscore
//

import Foundation

enum SearchType: String, Codable {
    case fixtures
    case competitions
    case teams
}

// MARK: - Flexible ID

enum SearchResultID: Codable, Hashable {
    case string(String)
    case int(Int)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
            return
        }

        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
            return
        }

        throw DecodingError.typeMismatch(
            SearchResultID.self,
            DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Expected String or Int for search result id"
            )
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .string(let value):
            try container.encode(value)
        case .int(let value):
            try container.encode(value)
        }
    }

    var stringValue: String {
        switch self {
        case .string(let value):
            return value
        case .int(let value):
            return String(value)
        }
    }
}

// MARK: - Fixture Search Result

struct FixtureSearchResultData: Codable, Hashable {
    let fixture: FixtureInfo
    let league: FixtureLeague
    let teams: MatchTeams
}

struct FixtureSearchResult: Codable, Identifiable, Hashable {
    let id: SearchResultID
    let type: SearchType
    let data: FixtureSearchResultData
}

// MARK: - Competition Search Result

struct CompetitionSearchResultData: Codable, Hashable {
    let league: FixtureLeague
}

struct CompetitionSearchResult: Codable, Identifiable, Hashable {
    let id: SearchResultID
    let type: SearchType
    let data: CompetitionSearchResultData
}

// MARK: - Team Search Result

struct TeamSearchResultData: Codable, Hashable {
    let team: Team
}

struct TeamSearchResult: Codable, Identifiable, Hashable {
    let id: SearchResultID
    let type: SearchType
    let data: TeamSearchResultData
}

enum SearchResult: Codable, Identifiable, Hashable {
    case fixture(FixtureSearchResult)
    case competition(CompetitionSearchResult)
    case team(TeamSearchResult)

    var id: SearchResultID {
        switch self {
        case .fixture(let result):
            return result.id
        case .competition(let result):
            return result.id
        case .team(let result):
            return result.id
        }
    }

    var type: SearchType {
        switch self {
        case .fixture:
            return .fixtures
        case .competition:
            return .competitions
        case .team:
            return .teams
        }
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(SearchType.self, forKey: .type)

        switch type {
        case .fixtures:
            let result = try FixtureSearchResult(from: decoder)
            self = .fixture(result)

        case .competitions:
            let result = try CompetitionSearchResult(from: decoder)
            self = .competition(result)

        case .teams:
            let result = try TeamSearchResult(from: decoder)
            self = .team(result)
        }
    }

    func encode(to encoder: Encoder) throws {
        switch self {
        case .fixture(let result):
            try result.encode(to: encoder)

        case .competition(let result):
            try result.encode(to: encoder)

        case .team(let result):
            try result.encode(to: encoder)
        }
    }
}

struct SearchResultGroup: Codable, Identifiable, Hashable {
    let type: SearchType
    let label: String
    let results: [SearchResult]

    var id: SearchType {
        type
    }
}
