//
//  SearchResultsGrouper.swift
//  Realscore
//

import Foundation

struct SearchResultsGrouper {
    private let labels: [SearchType: String] = [
        .fixtures: "Spiele",
        .competitions: "Wettbewerbe",
        .teams: "Teams"
    ]

    private let order: [SearchType] = [
        .competitions,
        .teams,
        .fixtures
    ]

    func group(_ results: [SearchResult]) -> [SearchResultGroup] {
        order.compactMap { type in
            let filteredResults = results.filter { $0.type == type }

            guard !filteredResults.isEmpty else {
                return nil
            }

            return SearchResultGroup(
                type: type,
                label: labels[type, default: ""],
                results: filteredResults
            )
        }
    }
}
