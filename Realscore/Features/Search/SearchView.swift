//
//  SearchView.swift
//  Realscore
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var searchText = ""

    private var trimmedSearchText: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        List {
            if trimmedSearchText.isEmpty {
                ContentUnavailableView(
                    "Suche starten",
                    systemImage: "magnifyingglass"
                )
                .listRowSeparator(.hidden)
            } else if viewModel.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .listRowSeparator(.hidden)
            } else if let errorMessage = viewModel.errorMessage {
                ContentUnavailableView(
                    errorMessage,
                    systemImage: "exclamationmark.triangle"
                )
                .listRowSeparator(.hidden)
            } else if viewModel.resultGroups.isEmpty {
                ContentUnavailableView(
                    "Keine Ergebnisse gefunden",
                    systemImage: "magnifyingglass"
                )
                .listRowSeparator(.hidden)
            } else {
                ForEach(viewModel.resultGroups) { group in
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
}
