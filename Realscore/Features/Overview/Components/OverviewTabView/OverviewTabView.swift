//
//  OverviewTabView.swift
//  Realscore
//

import SwiftUI

struct OverviewTabView: View {
    let fixtures: [Fixture]
    let errorMessage: String?
    let isLoading: Bool
    let didLoadInitialData: Bool
    let canReload: Bool
    let onFixtureTap: (Fixture) -> Void
    let onReload: () async -> Void

    var body: some View {
        OverviewFixturesListView(
            fixtures: fixtures,
            errorMessage: errorMessage,
            isLoading: isLoading,
            didLoadInitialData: didLoadInitialData,
            onRetry: reload,
            onRefresh: reload,
            onFixtureTap: onFixtureTap
        )
    }
    
    private func reload() async {
        guard canReload else { return }
        await onReload()
    }
}
