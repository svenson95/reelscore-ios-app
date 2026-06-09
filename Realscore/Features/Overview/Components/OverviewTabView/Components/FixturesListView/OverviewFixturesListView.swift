//
//  OverviewFixturesListView.swift
//  Realscore
//

import SwiftUI

struct OverviewFixturesListView: View {
    @State private var isRetrying = false

    let fixtures: [Fixture]

    let errorMessage: String?
    let isLoading: Bool
    let didLoadInitialData: Bool

    let onRetry: () async -> Void
    let onRefresh: () async -> Void
    let onFixtureTap: (Fixture) -> Void

    private var groupedFixtures: [FixtureSectionGroup] {
        fixtures.groupedByCompetitionAndRound()
    }

    private var shouldShowEmptyState: Bool {
        fixtures.isEmpty && !isLoading && !isRetrying && didLoadInitialData
    }

    private var showsRetryLoading: Bool {
        isRetrying || isLoading
    }

    var body: some View {
        List {
            errorSection
            emptySection
            fixtureSections
        }
        .refreshable {
            await onRefresh()
        }
    }

    @ViewBuilder
    private var errorSection: some View {
        if let errorMessage {
            ErrorView(
                message: errorMessage,
                isRetrying: showsRetryLoading
            ) {
                retry()
            }
        }
    }

    @MainActor
    private func retry() {
        guard !isRetrying else { return }

        isRetrying = true

        Task {
            await onRetry()

            await MainActor.run {
                isRetrying = false
            }
        }
    }

    @ViewBuilder
    private var emptySection: some View {
        if shouldShowEmptyState {
            EmptyStateView(
                title: "Keine Spiele",
                systemImage: "calendar"
            )
        }
    }

    private var fixtureSections: some View {
        ForEach(groupedFixtures) { group in
            Section {
                ForEach(group.fixtures) { fixture in
                    Button {
                        onFixtureTap(fixture)
                    } label: {
                        FixtureRowView(fixture: fixture)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            } header: {
                FixtureSectionHeaderView(group: group)
            }
        }
    }
}
