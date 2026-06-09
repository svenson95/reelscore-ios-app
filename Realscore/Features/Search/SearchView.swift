//
//  SearchView.swift
//  Realscore
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var searchText = ""

    var body: some View {
        List {
            resultsContent
        }
        .overlay {
            overlayContent
        }
        .navigationTitle("Suche")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(
            text: $searchText,
            prompt: "Team, Liga oder Spiel suchen"
        )
        .onChange(of: searchText) { _, newValue in
            viewModel.searchTextChanged(newValue)
        }
    }

    @ViewBuilder
    private var resultsContent: some View {
        if case .results(let groups) = viewModel.state {
            ForEach(groups) { group in
                Section {
                    ForEach(group.results) { result in
                        SearchResultRowView(result: result)
                    }
                } header: {
                    Text(group.label)
                }
            }
        }
    }

    @ViewBuilder
    private var overlayContent: some View {
        switch viewModel.state {
        case .idle, .tooShort:
            ContentUnavailableView(
                "Suche starten",
                systemImage: "magnifyingglass"
            )

        case .loading:
            ProgressView()

        case .failed(let message):
            ContentUnavailableView(
                message,
                systemImage: "exclamationmark.triangle"
            )

        case .empty:
            ContentUnavailableView(
                "Keine Ergebnisse gefunden",
                systemImage: "magnifyingglass"
            )

        case .results:
            EmptyView()
        }
    }
}
