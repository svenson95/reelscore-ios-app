//
//  OverviewContentView.swift
//  Realscore
//

import SwiftUI

struct OverviewContentView: View {
    @State private var isRetrying = false

    let fixtures: [Fixture]

    let errorMessage: String?
    let isLoading: Bool
    let didLoadInitialData: Bool

    let onRetry: () async -> Void
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
        errorSection
        emptySection
        fixtureSections
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
                    .foregroundColor(.primary)
                    .fontWeight(.light)
                    .textCase(nil)
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
}
