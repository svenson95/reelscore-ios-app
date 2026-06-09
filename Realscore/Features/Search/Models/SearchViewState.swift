//
//  SearchViewState.swift
//  Realscore
//

import Foundation

enum SearchViewState: Equatable {
    case idle
    case tooShort
    case loading
    case failed(String)
    case empty
    case results([SearchResultGroup])

    static func make(
        query: String,
        isLoading: Bool,
        errorMessage: String?,
        resultGroups: [SearchResultGroup]
    ) -> SearchViewState {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedQuery.isEmpty else {
            return .idle
        }

        guard trimmedQuery.count >= SearchViewModel.minimumQueryLength else {
            return .tooShort
        }

        if isLoading {
            return .loading
        }

        if let errorMessage {
            return .failed(errorMessage)
        }

        if resultGroups.isEmpty {
            return .empty
        }

        return .results(resultGroups)
    }
}
