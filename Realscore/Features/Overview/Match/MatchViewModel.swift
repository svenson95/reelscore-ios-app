//
//  MatchViewModel.swift
//  Realscore
//

import Foundation
import Combine

@MainActor
final class MatchViewModel: ObservableObject {
    @Published var fixture: Fixture

    init(fixture: Fixture) {
        self.fixture = fixture
    }
}
