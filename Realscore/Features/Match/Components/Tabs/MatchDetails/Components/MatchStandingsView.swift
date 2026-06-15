//
//  MatchStandingsView.swift
//  Realscore
//

import SwiftUI

private struct StandingSection: Identifiable {
    let id: Int
    let standingsDTO: StandingsDTO
    let ranks: [StandingRanks]
}

struct MatchStandingsView: View {
    let date: String
    let compId: CompetitionId
    let teamIds: String

    private let matchStandingsService = MatchStandingsService.shared

    @State private var standingsDTO: StandingsDTO?
    @State private var isLoading = false
    @State private var errorMessage: String?

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
            .compactMap { index, ranks in
                let filteredRanks = ranks.filter { rank in
                    teamIdSet.contains(String(rank.team.id))
                }

                guard !filteredRanks.isEmpty else {
                    return nil
                }

                return StandingSection(
                    id: index,
                    standingsDTO: standingsDTO,
                    ranks: filteredRanks
                )
            }
    }

    private var teamIdSet: Set<String> {
        Set(
            teamIds
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        )
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
}

private struct MatchStandingSectionView: View {
    let section: StandingSection

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Section {
            StandingsTableView(
                standings: section.ranks,
                competition: section.standingsDTO.league,
                titleOverride: title
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

    private var title: String? {
        if section.id == 1 {
            return "Heimtabelle"
        }
        if section.id == 2 {
            return "Auswärtstabelle"
        }
        return nil
    }
}
