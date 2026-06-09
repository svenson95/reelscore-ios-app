//
//  SearchViewModel.swift
//  Realscore
//

import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    static let minimumQueryLength = 3

    @Published private(set) var query = ""
    @Published private(set) var resultGroups: [SearchResultGroup] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let service: SearchServiceProvider
    private let grouper: SearchResultsGrouper
    private let debounceMilliseconds: UInt64

    private var searchTask: Task<Void, Never>?
    private var latestQuery = ""

    var state: SearchViewState {
        SearchViewState.make(
            query: query,
            isLoading: isLoading,
            errorMessage: errorMessage,
            resultGroups: resultGroups
        )
    }

    init(
        service: SearchServiceProvider? = nil,
        grouper: SearchResultsGrouper? = nil,
        debounceMilliseconds: UInt64 = 350
    ) {
        self.service = service ?? SearchService.shared
        self.grouper = grouper ?? SearchResultsGrouper()
        self.debounceMilliseconds = debounceMilliseconds
    }

    deinit {
        searchTask?.cancel()
    }

    func searchTextChanged(_ text: String) {
        searchTask?.cancel()

        let normalizedQuery = normalizedQuery(from: text)

        query = normalizedQuery
        latestQuery = normalizedQuery

        guard normalizedQuery.count >= Self.minimumQueryLength else {
            resetSearchState()
            return
        }

        startSearch(for: normalizedQuery)
    }

    private func startSearch(for query: String) {
        errorMessage = nil

        searchTask = Task { [weak self] in
            guard let self else { return }

            do {
                try await Task.sleep(for: .milliseconds(self.debounceMilliseconds))
                try Task.checkCancellation()

                self.isLoading = true

                let results = try await self.service.search(by: query)

                try Task.checkCancellation()

                self.applyResults(results, for: query)
            } catch is CancellationError {
                // ignore
            } catch {
                self.applySearchFailure(for: query)
            }
        }
    }

    private func applyResults(_ results: [SearchResult], for query: String) {
        guard latestQuery == query else {
            return
        }

        resultGroups = grouper.group(results)
        isLoading = false
        errorMessage = nil
    }

    private func applySearchFailure(for query: String) {
        guard latestQuery == query else {
            return
        }

        resultGroups = []
        isLoading = false
        errorMessage = "Suche fehlgeschlagen"
    }

    private func resetSearchState() {
        resultGroups = []
        isLoading = false
        errorMessage = nil
    }

    private func normalizedQuery(from text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
