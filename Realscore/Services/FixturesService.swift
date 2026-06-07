//
//  FixturesService.swift
//  Realscore
//

import Foundation

final class FixturesService {
    static let shared = FixturesService()

    private init() {}

    func getWeekFixtures(
        date: String,
        withEdgeDays: Bool
    ) async throws -> [[Fixture]] {
        var components = URLComponents(
            string: "https://reelscore-api-svenson95s-projects.vercel.app/fixtures/by-date"
        )!

        components.queryItems = [
            URLQueryItem(name: "date", value: date),
            URLQueryItem(name: "withEdgeDays", value: withEdgeDays ? "true" : "false")
        ]

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([[Fixture]].self, from: data)
    }
}
