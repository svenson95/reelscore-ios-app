//
//  StandingsView.swift
//  Realscore
//

import SwiftUI

struct StandingsView: View {
    @StateObject private var viewModel = StandingsViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.standings.isEmpty {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage {
                ContentUnavailableView(
                    "Fehler",
                    systemImage: "exclamationmark.triangle",
                    description: Text(errorMessage)
                )
            } else if viewModel.standings.isEmpty {
                ContentUnavailableView(
                    "Keine Tabellen",
                    systemImage: "tablecells",
                    description: Text("Es wurden keine Tabellen gefunden.")
                )
            } else {
                standingsList
            }
        }
        .navigationTitle("Tabellen")
        .task {
            await viewModel.loadInitialStandings()
        }
    }

    private var standingsList: some View {
        List {
            ForEach(viewModel.standings) { standingsDTO in
                Section {
                    StandingsTableView(
                        standings: flattenedRows(from: standingsDTO),
                        competition: standingsDTO.league
                    )
                }
            }
        }
    }

    private func flattenedRows(from standingsDTO: StandingsDTO) -> [StandingRanks] {
        standingsDTO.league.standings.flatMap { $0 }
    }
}

#Preview {
    StandingsView()
}
