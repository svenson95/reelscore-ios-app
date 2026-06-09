//
//  CompetitionSelectViewModel.swift
//  Realscore
//

import Foundation
import Combine

@MainActor
final class CompetitionSelectViewModel: ObservableObject {
    @Published var competitionGroups: [SelectCompetitionGroup] = []
    @Published var competitions: [Competition] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadCompetitions() async {
        isLoading = false
        errorMessage = nil

        competitionGroups = StaticCompetitionData.groups
        competitions = StaticCompetitionData.flat
    }
}
