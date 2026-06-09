//
//  Fixture.swift
//  Realscore
//

import Foundation

// MARK: - Typealiases

public typealias MongoDbId = String
typealias FixtureStatusShort = String

// MARK: - Fixture

struct Fixture: Identifiable, Codable, Hashable {
    let _id: MongoDbId?
    let fixture: FixtureInfo
    let league: FixtureLeague
    let teams: MatchTeams
    let goals: Goals
    let score: Score
    let final: FixtureFinal?
    let prediction: FixturePrediction?
    let evaluations: FixtureEvaluations?

    var id: Int {
        if let intId = fixture.idAsInt {
            return intId
        }

        return fixture.id.hashValue
    }

    var displayName: String {
        "\(teams.home.name.teamName()) - \(teams.away.name.teamName())"
    }

    var kickoffDate: String {
        fixture.date
    }

    enum CodingKeys: String, CodingKey {
        case _id
        case fixture
        case league
        case teams
        case goals
        case score
        case final
        case prediction
        case evaluations
    }

    static func == (lhs: Fixture, rhs: Fixture) -> Bool {
        lhs.fixture.id == rhs.fixture.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(fixture.id)
    }
}

struct FixtureInfo: Codable, Hashable {
    let id: FixtureId
    let referee: String?
    let timezone: String
    let date: String
    let timestamp: Int
    let periods: FixturePeriods
    let venue: FixtureVenue
    let status: FixtureStatus

    var idAsInt: Int? {
        switch id {
        case .int(let value):
            return value
        case .string(let value):
            return Int(value)
        }
    }
}

enum FixtureId: Codable, Hashable {
    case int(Int)
    case string(String)

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
            FixtureId.self,
            DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "FixtureId must be Int or String"
            )
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .int(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        }
    }
}

struct FixturePeriods: Codable, Hashable {
    let first: Int?
    let second: Int?
}

struct FixtureVenue: Codable, Hashable {
    let id: Int?
    let name: String?
    let city: String?
}

struct FixtureStatus: Codable, Hashable {
    let long: String
    let short: FixtureStatusShort
    let elapsed: Int?
    let extra: Int?
}

struct FixtureLeague: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let country: String?
    let logo: String?
    let flag: String?
    let season: Int?
    let round: String?
}

struct MatchTeams: Codable, Hashable {
    let home: FixtureTeam
    let away: FixtureTeam
}

struct FixtureTeam: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let logo: String?
    let winner: Bool?
}

struct Goals: Codable, Hashable {
    let home: Int?
    let away: Int?
}

struct Score: Codable, Hashable {
    let halftime: Goals
    let fulltime: Goals
    let extratime: Goals
    let penalty: Goals
}

struct FixtureFinal: Codable, Hashable {
    let firstLegResult: Goals?
    let winnerOfFinal: TeamId?
}

struct FixturePrediction: Codable, Hashable {
    let bet: String
    let qoute: Double
    let probability: Double
    let correct: Bool?
}

struct FixtureEvaluations: Codable, Hashable {
    let home: FixtureEvaluation
    let away: FixtureEvaluation
}

struct FixtureEvaluation: Codable, Hashable {
    let performance: EvaluationPerformance?
    let analyses: [EvaluationAnalysis]
}

struct EvaluationAnalysis: Codable, Hashable {
    let level: AnalysisLevel?
    let type: AnalysisType?
    let minute: Int?
    let player: String?
    let comments: String?
}

enum EvaluationPerformance: String, Codable, Hashable {
    case low = "LOW"
    case middle = "MIDDLE"
    case high = "HIGH"
}

enum AnalysisLevel: String, Codable, Hashable {
    case lucky = "LUCKY"
    case unlucky = "UNLUCKY"
}

enum AnalysisType: String, Codable, Hashable {
    case goal = "GOAL"
    case noGoal = "NO_GOAL"
    case lastMinuteGoal = "LAST_MINUTE_GOAL"
    case noFoul = "NO_FOUL"
    case penalty = "PENALTY"
    case noPenalty = "NO_PENALTY"
    case redCard = "RED_CARD"
    case noRedCard = "NO_RED_CARD"
    case keyPlayerInjury = "KEY_PLAYER_INJURY"
    case keyPlayerYellowCardSuspension = "KEY_PLAYER_YELLOW_CARD_SUSPENSION"
}

extension FixtureStatusShort {
    var isHalftime: Bool {
        self == "HT"
    }
    
    var isScheduled: Bool {
        ["TBD", "NS"].contains(self)
    }

    var isPlaying: Bool {
        ["1H", "2H", "ET", "BT", "P", "INT"].contains(self) || isHalftime
    }

    var isFinished: Bool {
        ["FT", "AET", "PEN"].contains(self)
    }
    
    var isCancelled: Bool {
        self == "CANC"
    }
    
    var isAbandoned: Bool {
        self == "ABD"
    }
    
    var isNotPlayed: Bool {
        ["AWD", "WO"].contains(self)
    }
    
    var isEnded: Bool {
        isFinished || isCancelled || isAbandoned || isNotPlayed
    }
    
    var isEndedWithoutPlaying: Bool {
        isCancelled || isAbandoned || isNotPlayed
    }
}
