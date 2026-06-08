//
//  SearchViewModel.swift
//  Realscore
//

import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    @Published private var results: [SearchResult] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var searchTask: Task<Void, Never>?
    private var latestQuery = ""
    
    var resultGroups: [SearchResultGroup] {
        let labels: [SearchType: String] = [
            .fixtures: "Spiele",
            .competitions: "Wettbewerbe",
            .teams: "Teams"
        ]

        let order: [SearchType] = [
            .competitions,
            .teams,
            .fixtures
        ]

        return order.compactMap { type in
            let filteredResults = results.filter { $0.type == type }

            guard !filteredResults.isEmpty else {
                return nil
            }

            return SearchResultGroup(
                type: type,
                label: labels[type] ?? "",
                results: filteredResults
            )
        }
    }

    func searchTextChanged(_ text: String) {
        searchTask?.cancel()

        let query = text.trimmingCharacters(in: .whitespacesAndNewlines)
        latestQuery = query

        guard query.count >= 3 else {
            results = []
            isLoading = false
            errorMessage = nil
            return
        }

        isLoading = true
        errorMessage = nil

        searchTask = Task { [weak self] in
            do {
                try await Task.sleep(for: .milliseconds(350))
                try Task.checkCancellation()

                let searchResults = try await Self.fetchSearchResults(query: query)

                try Task.checkCancellation()

                await MainActor.run {
                    guard self?.latestQuery == query else {
                        return
                    }

                    self?.results = searchResults
                    self?.isLoading = false
                    self?.errorMessage = nil
                }
            } catch is CancellationError {
                // ignorieren
            } catch {
                await MainActor.run {
                    guard self?.latestQuery == query else {
                        return
                    }

                    self?.results = []
                    self?.isLoading = false
                    self?.errorMessage = "Suche fehlgeschlagen"
                }
            }
        }
    }

    nonisolated private static func fetchSearchResults(query: String) async throws -> [SearchResult] {
        try await SearchService.shared.search(by: query)
    }
}
