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

// MARK: - Competition

struct Competition: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let type: String?
    let logo: String?
    let country: String?
    let season: Int?
}
