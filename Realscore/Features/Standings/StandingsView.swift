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
                List {
                    ForEach(viewModel.standings) { standingsDTO in
                        Section {
                            StandingsHeaderView()

                            ForEach(flattenedRows(from: standingsDTO)) { row in
                                StandingsRowView(standing: row)
                            }
                        } header: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(standingsDTO.league.name)
                                    .font(.headline)

                                if let round = standingsDTO.league.round {
                                    Text(round)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Tabellen")
        .task {
            await viewModel.loadInitialStandings()
        }
    }

    private func flattenedRows(from standingsDTO: StandingsDTO) -> [StandingRanks] {
        standingsDTO.league.standings.flatMap { $0 }
    }
}
