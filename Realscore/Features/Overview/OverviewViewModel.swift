//
//  OverviewViewModel.swift
//  Realscore
//

import Foundation
import Combine

@MainActor
final class OverviewViewModel: ObservableObject {
    @Published var fixtures: [Fixture] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var hasLoaded = false

    func loadOverviewIfNeeded() async {
        guard !hasLoaded else { return }

        hasLoaded = true
        await loadOverview()
    }

    func loadOverview() async {
        isLoading = true
        errorMessage = nil

        do {
            let today = Date()
            let dateString = today.apiDateString

            let weekData = try await FixturesAPI.shared.getWeekFixtures(date: dateString)
            let todayIndex = today.weekdayIndexMondayBased

            if weekData.indices.contains(todayIndex) {
                fixtures = weekData[todayIndex]
            } else {
                fixtures = []
                errorMessage = "Keine Fixtures für den heutigen Tag gefunden."
            }
        } catch {
            fixtures = []
            errorMessage = error.localizedDescription
            print("❌ Failed to load overview:", error.localizedDescription)
        }

        isLoading = false
    }
}
