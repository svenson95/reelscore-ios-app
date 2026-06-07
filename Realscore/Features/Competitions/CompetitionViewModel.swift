//
//  CompetitionViewModel.swift
//  Realscore
//

import Foundation
import Combine

@MainActor
final class CompetitionViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadCompetition(competitionId: Int) async {
        isLoading = true
        errorMessage = nil

        isLoading = false
    }
}
