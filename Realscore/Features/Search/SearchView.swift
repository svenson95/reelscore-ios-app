//
//  SearchView.swift
//  Realscore
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SearchViewModel()
    @State private var searchText = ""

    var body: some View {
        List {
            if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                EmptyStateView(
                    title: "Suche starten",
                    systemImage: "magnifyingglass"
                )
            } else {
                ForEach(viewModel.results) { result in
                    SearchResultRowView(result: result)
                }
            }
        }
        .navigationTitle("Suche")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Team, Liga oder Spiel suchen"
        )
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Text("Done")
                }
            }
        }
        .onChange(of: searchText) { _, newValue in
            viewModel.search(query: newValue)
        }
    }
}
