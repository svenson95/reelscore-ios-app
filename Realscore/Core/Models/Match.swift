//
//  Match.swift
//  Realscore
//

import Foundation

struct Match: Identifiable, Codable, Hashable {
    let id: Int
    let fixture: Fixture
}
