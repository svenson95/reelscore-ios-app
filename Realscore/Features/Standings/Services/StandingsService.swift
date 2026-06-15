//
//  StandingsService.swift
//  Realscore
//

import Foundation

final class StandingsService {
    static let shared = StandingsService()

    init() {}

    func getStandings(date: String, withEdgeDays: Bool) async throws -> [[StandingsDTO]] {
        var components = URLComponents(string: "\(Constants.baseURL)/standings/start-top-five")!

        components.queryItems = [
            URLQueryItem(name: "date", value: date),
        ]

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        print("Standings URL:", url.absoluteString)

        let (data, response) = try await URLSession.shared.data(from: url)

        if let httpResponse = response as? HTTPURLResponse {
            print("Standings status code:", httpResponse.statusCode)

            guard (200...299).contains(httpResponse.statusCode) else {
                let body = String(data: data, encoding: .utf8) ?? "-"
                print("Standings error body:", body)
                throw URLError(.badServerResponse)
            }
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return try decoder.decode([[StandingsDTO]].self, from: data)
    }
}
