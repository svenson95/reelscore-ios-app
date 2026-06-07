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
        let url = Constants.baseURL
            .appendingPathComponent("fixtures")
            .appendingPathComponent("by-date")
            .appending(queryItems: [URLQueryItem.init(name: "withEdgeDays", value: "true")])

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([[Fixture]].self, from: data)
    }
}
