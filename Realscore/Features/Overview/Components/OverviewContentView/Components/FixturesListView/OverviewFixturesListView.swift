//
//  OverviewFixturesListView.swift
//  Realscore
//

import SwiftUI

struct OverviewFixturesListView: View {
    @State private var isRefreshing = false

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

    private var isBusy: Bool {
        isLoading || isRefreshing
    }

    private var shouldShowEmptyState: Bool {
        fixtures.isEmpty && !isBusy && didLoadInitialData
    }

    private var showsRetryLoading: Bool {
        isBusy && fixtures.isEmpty
    }

    private var shouldShowInlineLoading: Bool {
        isBusy && didLoadInitialData && fixtures.isEmpty
    }

    var body: some View {
        List {
            errorSection
            inlineLoadingSection
            emptySection
            fixtureSections
        }
        .refreshable {
            await refresh()
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
        guard !isRefreshing else { return }

        isRefreshing = true

        Task {
            await onRetry()

            await MainActor.run {
                isRefreshing = false
            }
        }
    }

    @MainActor
    private func refresh() async {
        guard !isRefreshing else { return }

        isRefreshing = true
        await onRefresh()
        isRefreshing = false
    }
}
