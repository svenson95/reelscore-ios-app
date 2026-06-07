//
//  CompetitionView.swift
//  Realscore
//

import SwiftUI

import SwiftUI

struct CompetitionView: View {
    let competitionId: Int

    @StateObject private var viewModel = CompetitionViewModel()

    var body: some View {
        List {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .navigationTitle("Wettbewerb")
        .task {
            await viewModel.loadCompetition(competitionId: competitionId)
        }
    }
}
