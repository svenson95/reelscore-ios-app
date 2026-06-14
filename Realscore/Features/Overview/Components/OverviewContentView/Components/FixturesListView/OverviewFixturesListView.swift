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

    private var shouldShowInlineLoading: Bool {
        isLoading && didLoadInitialData
    }

    var body: some View {
        List {
            errorSection
            inlineLoadingSection
            emptySection
            fixtureSections
        }
        .refreshable {
            await onRefresh()
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
    private var inlineLoadingSection: some View {
        if shouldShowInlineLoading {
            Section {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding(.vertical, 8)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
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
