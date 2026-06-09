//
//  LeagueRelegationRoundMap.swift
//  Realscore
//

import Foundation

enum LeagueRelegationRoundMap {
    static let values: RoundMapOverride = [
        "Final": { _ in
            RoundLabelTranslation(
                standard: "Relegation",
                header: "Relegation"
            )
        }
    ]
}
