//
//  Team.swift
//  Realscore
//

import Foundation

struct Team: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let logo: String?
}
