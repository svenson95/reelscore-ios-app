//
//  StandingsViewModel.swift
//  Realscore
//

import Foundation
import Combine

@MainActor
final class StandingsViewModel: ObservableObject {
    @Published private(set) var standingsGroups: [[StandingsDTO]] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var didLoadInitialData = false

    private let standingsService = StandingsService.shared
    private var didLoad = false

    var standings: [StandingsDTO] {
        standingsGroups.first ?? []
    }

    func loadInitialStandings() async {
        guard !didLoad else { return }

        didLoad = true
        didLoadInitialData = true

        await loadStandings(for: Date(), withEdgeDays: false)
    }

    func loadStandings(for date: Date, withEdgeDays: Bool = false) async {
        isLoading = true
        errorMessage = nil

        do {
            let dateString = date.apiDateString

            standingsGroups = try await standingsService.getStandings(
                date: dateString,
                withEdgeDays: withEdgeDays
            )
        } catch {
            print("Standings loading error:", error)
            errorMessage = "Tabellen konnten nicht geladen werden"
        }

        isLoading = false
    }
}
