//
//  FixturesAPI.swift
//  Realscore
//

import Foundation

final class FixturesAPI {
    static let shared = FixturesAPI()

    private init() {}

    func getWeekFixtures(date: String) async throws -> [[Fixture]] {
        let url = Constants.baseURL
            .appendingPathComponent("fixtures")
            .appendingPathComponent("by-date")

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw URLError(.badURL)
        }

        components.queryItems = [
            URLQueryItem(name: "date", value: date)
        ]

        guard let finalURL = components.url else {
            throw URLError(.badURL)
        }

        return try await APIClient.shared.get(finalURL)
    }
}
