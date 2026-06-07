//
//  Standing.swift
//  Realscore
//

import Foundation

struct Standing: Identifiable, Codable, Hashable {
    let id: Int
    let position: Int
    let team: Team
    let played: Int?
    let points: Int?
    let wins: Int?
    let draws: Int?
    let losses: Int?
}
