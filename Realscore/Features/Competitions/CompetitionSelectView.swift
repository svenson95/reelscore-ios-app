//
//  CompetitionSelectView.swift
//  Realscore
//

import SwiftUI

struct CompetitionSelectView: View {
    @StateObject private var viewModel = CompetitionSelectViewModel()

    var body: some View {
        List {
            if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage) {
                    Task {
                        await viewModel.loadCompetitions()
                    }
                }
            }

            ForEach(viewModel.competitionGroups) { group in
                Section(group.title) {
                    ForEach(group.competitions) { competition in
                        NavigationLink {
                            CompetitionView(competitionId: competition.id)
                        } label: {
                            Label(competition.name, systemImage: "trophy")
                        }
                    }
                }
            }
        }
        .navigationTitle("Wettbewerbe")
        .task {
            await viewModel.loadCompetitions()
        }
    }
}
