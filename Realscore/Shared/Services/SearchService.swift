//
//  SearchService.swift
//  Realscore
//

import Foundation

final class SearchService {
    static let shared = SearchService()

    private init() {}

    func search(by query: String) async throws -> [SearchResult] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedQuery.isEmpty else {
            return []
        }

        var components = URLComponents(string: "\(Constants.baseURL)/search")!

        components.queryItems = [
            URLQueryItem(name: "searchTerm", value: trimmedQuery)
        ]

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        print("Search URL:", url.absoluteString)

        let (data, response) = try await URLSession.shared.data(from: url)

        try Task.checkCancellation()

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        print("Search status code:", httpResponse.statusCode)

        guard (200...299).contains(httpResponse.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? "-"
            print("Search error body:", body)
            throw URLError(.badServerResponse)
        }

        do {
            return try JSONDecoder().decode([SearchResult].self, from: data)
        } catch {
            let body = String(data: data, encoding: .utf8) ?? "-"
            print("Search decoding failed:")
            print(error)
            print("Search response body:", body)
            throw error
        }
    }
}
