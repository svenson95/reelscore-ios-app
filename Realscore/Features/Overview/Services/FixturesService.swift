//
//  FixturesService.swift
//  Realscore
//

import Foundation

final class FixturesService: FixturesServiceProvider {
    static let shared = FixturesService()

    private let session: URLSession
    private let decoder: JSONDecoder

    private init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }

    func getWeekFixtures(date: String, withEdgeDays: Bool) async throws -> [[Fixture]] {
        var components = URLComponents(string: "\(Constants.baseURL)/fixtures/by-date")

        components?.queryItems = [
            URLQueryItem(name: "date", value: date),
            URLQueryItem(name: "withEdgeDays", value: String(withEdgeDays))
        ]

        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        print("Request: ", url)
        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        print("Response: ", httpResponse.statusCode)
        guard (200...299).contains(httpResponse.statusCode) else {
            throw FixturesServiceError.requestFailed(
                statusCode: httpResponse.statusCode,
                body: String(data: data, encoding: .utf8)
            )
        }

        return try decoder.decode([[Fixture]].self, from: data)
    }
}

enum FixturesServiceError: LocalizedError {
    case requestFailed(statusCode: Int, body: String?)

    var errorDescription: String? {
        switch self {
        case .requestFailed(let statusCode, _):
            return "Fixtures request failed with status code \(statusCode)."
        }
    }
}
