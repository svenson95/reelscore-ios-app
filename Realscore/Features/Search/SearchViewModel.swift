//
//  SearchViewModel.swift
//  Realscore
//

import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var results: [SearchResult] = []

    func search(query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedQuery.isEmpty else {
            results = []
            return
        }

        // TODO: später echte Suche / API-Call
        results = []
    }
}

struct SearchResult: Identifiable, Hashable {
    let id: Int
    let title: String
    let subtitle: String
}
