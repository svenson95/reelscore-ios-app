//
//  Competition.swift
//  Realscore
//

import Foundation

// MARK: - Typealiases

public typealias CompetitionId = Int
public typealias CompetitionSeason = Int
public typealias CompetitionName = String
public typealias CompetitionRound = String
public typealias CompetitionUrl = String

// MARK: - Competition

struct Competition: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let type: String?
    let logo: String?
    let country: String?
    let season: Int?
}

// MARK: - CompetitionGroup

struct CompetitionGroup: Identifiable, Hashable {
    let title: String
    let competitions: [CompetitionData]

    var id: String {
        title
    }
}

struct CompetitionData: Identifiable, Hashable {
    let code: CompetitionCode
    let apiId: CompetitionId
    let name: CompetitionName
    let url: CompetitionUrl

    var id: CompetitionCode {
        code
    }
}
