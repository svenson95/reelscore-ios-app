//
//  OverviewContentView.swift
//  Realscore
//

import SwiftUI

struct OverviewContentView: View {
    let fixtures: [Fixture]

    let errorMessage: String?
    let isLoading: Bool
    let didLoadInitialData: Bool

    let onRetry: () async -> Void
    let onRefresh: () async -> Void
    let onFixtureTap: (Fixture) -> Void

    private var shouldShowLoadingState: Bool {
        isLoading && !didLoadInitialData && fixtures.isEmpty
    }

    var body: some View {
        if shouldShowLoadingState {
            loadingView
        } else {
            OverviewFixturesListView(
                fixtures: fixtures,
                errorMessage: errorMessage,
                isLoading: isLoading,
                didLoadInitialData: didLoadInitialData,
                onRetry: onRetry,
                onRefresh: onRefresh,
                onFixtureTap: onFixtureTap
            )
        }
    }

    @ViewBuilder
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
    }
}
