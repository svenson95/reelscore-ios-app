//
//  FixturesServiceProvider.swift
//  Realscore
//

import Foundation

protocol FixturesServiceProvider {
    func getWeekFixtures(date: String, withEdgeDays: Bool) async throws -> [[Fixture]]
}
