//
//  Fixture.swift
//  Realscore
//

import Foundation

// MARK: - Typealiases

public typealias MongoDbId = String
public typealias VenueId = Int
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
    let id: VenueId?
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


enum FixtureMock {
    static let example: Fixture = decodeFixture(from: exampleJSON)

    private static func decodeFixture(from json: String) -> Fixture {
        guard let data = json.data(using: .utf8) else {
            fatalError("Invalid fixture mock JSON")
        }

        do {
            return try JSONDecoder().decode(Fixture.self, from: data)
        } catch {
            fatalError("Failed to decode fixture mock: \(error)")
        }
    }

    private static let exampleJSON = """
    {
      "_id": "6a161cb1a8cabfceb9e416e4",
      "fixture": {
        "id": 1489373,
        "referee": "Said Martinez, Honduras",
        "timezone": "Europe/Berlin",
        "date": "2026-06-13T19:00:00.000Z",
        "timestamp": 1781377200,
        "periods": {
          "first": null,
          "second": null
        },
        "venue": {
          "id": null,
          "name": "Levi's Stadium",
          "city": "San Francisco Bay Area"
        },
        "status": {
          "long": "Not Started",
          "short": "NS",
          "elapsed": null,
          "extra": null
        }
      },
      "league": {
        "id": 1,
        "name": "World Cup",
        "country": "World",
        "logo": "https://media.api-sports.io/football/leagues/1.png",
        "flag": null,
        "season": 2026,
        "round": "Group Stage - 1"
      },
      "teams": {
        "home": {
          "id": 1569,
          "name": "Qatar",
          "logo": "https://media.api-sports.io/football/teams/1569.png",
          "winner": null
        },
        "away": {
          "id": 15,
          "name": "Switzerland",
          "logo": "https://media.api-sports.io/football/teams/15.png",
          "winner": null
        }
      },
      "goals": {
        "home": null,
        "away": null
      },
      "score": {
        "halftime": {
          "home": null,
          "away": null
        },
        "fulltime": {
          "home": null,
          "away": null
        },
        "extratime": {
          "home": null,
          "away": null
        },
        "penalty": {
          "home": null,
          "away": null
        }
      },
      "final": {
        "firstLegResult": null,
        "winnerOfFinal": null
      },
      "prediction": null,
      "evaluations": null,
      "createdAt": "2026-05-27T00:20:33.649Z",
      "updatedAt": "2026-06-13T19:02:33.578Z",
      "__v": 0
    }
    """
}
