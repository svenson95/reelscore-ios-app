//
//  MatchStandingsView.swift
//  Realscore
//

import SwiftUI

private struct StandingSection: Identifiable {
    let id: Int
    let competition: StandingsLeague
    let ranks: [StandingRanks]
    let title: String?
    let tableKind: StandingsTableKind
}

struct MatchStandingsView: View {
    let date: String
    let compId: CompetitionId
    let teamIds: String

    private let matchStandingsService = MatchStandingsService.shared

    @State private var standingsDTO: StandingsDTO?
    @State private var isLoading = false
    @State private var errorMessage: String?

    private var teamIdSet: Set<String> {
        Set(
            teamIds
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        )
    }

    var body: some View {
        content
            .task(id: "\(date)-\(String(compId))-\(teamIds)") {
                await loadStandings()
            }
    }

    @ViewBuilder
    private var content: some View {
        if isLoading {
            ProgressView()
        } else if let errorMessage {
            Text(errorMessage)
                .foregroundStyle(.secondary)
                .font(.footnote)
        } else if filteredStandingSections.isEmpty {
            Text("No standings available")
                .foregroundStyle(.secondary)
                .font(.footnote)
        } else {
            standingsList(filteredStandingSections)
        }
    }

    private func standingsList(_ sections: [StandingSection]) -> some View {
        VStack(alignment: .leading, spacing: AppLayout.small) {
            ForEach(sections) { section in
                MatchStandingSectionView(section: section)
            }
        }
    }

    private var filteredStandingSections: [StandingSection] {
        guard let standingsDTO else {
            return []
        }

        return standingsDTO.league.standings
            .enumerated()
            .compactMap { index, ranks -> StandingSection in
                StandingSection(
                    id: index,
                    competition: standingsDTO.league,
                    ranks: ranks,
                    title: standingsTitle(index),
                    tableKind: tableKind(index)
                )
            }
    }

    @MainActor
    private func loadStandings() async {
        guard !teamIdSet.isEmpty else {
            standingsDTO = nil
            errorMessage = "No teams available"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            standingsDTO = try await matchStandingsService.getMatchStandings(
                date: date,
                compId: compId,
                teamIds: teamIds
            )
        } catch {
            standingsDTO = nil
            errorMessage = "Could not load standings"
            print("Failed to load match standings:", error)
        }

        isLoading = false
    }

    private func tableKind(_ index: Int) -> StandingsTableKind {
        switch index {
        case 1:
            return .home
        case 2:
            return .away
        default:
            return .all
        }
    }

    private func standingsTitle(_ index: Int) -> String? {
        switch index {
        case 1:
            return "Heimtabelle"
        case 2:
            return "Auswärtstabelle"
        default:
            return nil
        }
    }
}

private struct MatchStandingSectionView: View {
    let section: StandingSection

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Section {
            StandingsTableView(
                standings: section.ranks,
                competition: section.competition,
                titleOverride: section.title,
                tableKind: section.tableKind
            )
        }
        .padding(AppLayout.medium)
        .background(sectionBackground)
        .cornerRadius(AppLayout.cornerRadius)
    }

    private var sectionBackground: Color {
        colorScheme == .dark
            ? Color(uiColor: .secondarySystemBackground)
            : Color(uiColor: .secondarySystemGroupedBackground)
    }
}
