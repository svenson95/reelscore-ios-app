//
//  Competition.swift
//  Realscore
//

import Foundation

struct Competition: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let type: String?
    let logo: String?
    let country: String?
    let season: Int?
}
