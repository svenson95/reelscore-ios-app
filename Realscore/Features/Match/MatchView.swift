//
//  MatchView.swift
//  Realscore
//

import SwiftUI

struct MatchView: View {
    @StateObject private var viewModel: MatchViewModel

    init(fixture: Fixture) {
        _viewModel = StateObject(wrappedValue: MatchViewModel(fixture: fixture))
    }

    var body: some View {
        List {
            MatchHeaderView(fixture: viewModel.fixture)
            MatchStatsView(fixture: viewModel.fixture)
        }
        .navigationTitle("Partie")
        .navigationBarTitleDisplayMode(.inline)
    }
}
