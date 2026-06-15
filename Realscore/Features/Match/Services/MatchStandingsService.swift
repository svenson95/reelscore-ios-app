//
//  MatchStandingsService.swift
//  Realscore
//

import Foundation

final class MatchStandingsService {
    static let shared = MatchStandingsService()

    init() {}

    func getMatchStandings(date: String, compId: CompetitionId, teamIds: String)
        async throws -> StandingsDTO
    {
        var components = URLComponents(
            string: "\(Constants.baseURL)/standings/match-standings"
        )!

        components.queryItems = [
            URLQueryItem(name: "teamIds", value: teamIds),
            URLQueryItem(name: "competition", value: String(compId)),
            URLQueryItem(name: "date", value: date),
        ]

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        print("Match-Standings URL:", url.absoluteString)

        let (data, response) = try await URLSession.shared.data(from: url)

        if let httpResponse = response as? HTTPURLResponse {
            print("Match-Standings status code:", httpResponse.statusCode)

            guard (200...299).contains(httpResponse.statusCode) else {
                let body = String(data: data, encoding: .utf8) ?? "-"
                print("Match-Standings error body:", body)
                throw URLError(.badServerResponse)
            }
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return try decoder.decode(StandingsDTO.self, from: data)
    }
}
