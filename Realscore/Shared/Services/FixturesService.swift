//
//  FixturesService.swift
//  Realscore
//

import Foundation

final class FixturesService {
    static let shared = FixturesService()

    init() {}

    func getWeekFixtures(date: String, withEdgeDays: Bool) async throws -> [[Fixture]] {
        var components = URLComponents(string: "\(Constants.baseURL)/fixtures/by-date")!

        components.queryItems = [
            URLQueryItem(name: "date", value: date),
            URLQueryItem(name: "withEdgeDays", value: withEdgeDays ? "true" : "false")
        ]

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        print("Fixtures URL:", url.absoluteString)

        let (data, response) = try await URLSession.shared.data(from: url)

        if let httpResponse = response as? HTTPURLResponse {
            print("Fixtures status code:", httpResponse.statusCode)

            guard (200...299).contains(httpResponse.statusCode) else {
                let body = String(data: data, encoding: .utf8) ?? "-"
                print("Fixtures error body:", body)
                throw URLError(.badServerResponse)
            }
        }

        print("Fixtures raw response:")
        print(String(data: data, encoding: .utf8) ?? "-")

        return try JSONDecoder().decode([[Fixture]].self, from: data)
    }
}
