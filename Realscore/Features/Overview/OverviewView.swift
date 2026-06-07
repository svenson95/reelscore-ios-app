//
//  OverviewView.swift
//  Realscore
//

import SwiftUI

struct OverviewView: View {
    @StateObject private var viewModel = OverviewViewModel()

    var body: some View {
        List {
            if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage) {
                    Task {
                        await viewModel.loadOverview()
                    }
                }
            }

            ForEach(viewModel.fixtures) { fixture in
                NavigationLink {
                    MatchView(fixture: fixture)
                } label: {
                    FixtureRowView(fixture: fixture)
                }
            }
        }
        .overlay {
            if viewModel.isLoading && viewModel.fixtures.isEmpty {
                LoadingView()
            }
        }
        .navigationTitle("Überblick")
        .task {
            await viewModel.loadOverviewIfNeeded()
        }
        .refreshable {
            await viewModel.loadOverview()
        }
    }
}
