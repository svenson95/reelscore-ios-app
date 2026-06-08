//
//  Team.swift
//  Realscore
//

import Foundation

public typealias TeamId = Int

public struct Team: Identifiable, Codable, Hashable {
    public let id: Int
    public let name: String
    public let logo: String?
}
