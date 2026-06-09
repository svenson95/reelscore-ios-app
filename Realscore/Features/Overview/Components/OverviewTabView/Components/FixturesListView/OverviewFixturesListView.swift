//
//  OverviewFixturesListView.swift
//  Realscore
//

import SwiftUI

struct OverviewFixturesListView: View {
    let fixtures: [Fixture]

    let errorMessage: String?
    let isLoading: Bool
    let didLoadInitialData: Bool

    let onRetry: () async -> Void
    let onRefresh: () async -> Void

    private var groupedFixtures: [FixtureSectionGroup] {
        fixtures.groupedByCompetitionAndRound()
    }

    private var shouldShowEmptyState: Bool {
        fixtures.isEmpty && !isLoading && didLoadInitialData
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
            ErrorView(message: errorMessage) {
                Task {
                    await onRetry()
                }
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
                    NavigationLink {
                        MatchView(fixture: fixture)
                    } label: {
                        FixtureRowView(fixture: fixture)
                    }
                }
            } header: {
                FixtureSectionHeaderView(group: group)
            }
        }
    }
}
