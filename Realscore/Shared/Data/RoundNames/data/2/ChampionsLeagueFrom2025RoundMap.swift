//
//  ChampionsLeagueFrom2025RoundMap.swift
//  Realscore
//

import Foundation

enum ChampionsLeagueFrom2025RoundMap {
    static let values: RoundMapOverride = [
        "League Stage": { round in
            let number = RoundLabelHelpers.roundNumber(round)

            return RoundLabelTranslation(
                standard: "\(number). Spieltag",
                header: "\(number). Spieltag"
            )
        },

        "Knockout Round Play-offs": { _ in
            RoundLabelTranslation(
                standard: "Play-offs der K.-o.-Runde",
                header: "Play-offs"
            )
        },

        "Round of 16": { _ in
            RoundLabelTranslation(
                standard: "Achtelfinale",
                header: "Achtelfinale"
            )
        },

        "Quarter-finals": { _ in
            RoundLabelTranslation(
                standard: "Viertelfinale",
                header: "Viertelfinale"
            )
        },

        "Semi-finals": { _ in
            RoundLabelTranslation(
                standard: "Halbfinale",
                header: "Halbfinale"
            )
        },

        "Final": { _ in
            RoundLabelTranslation(
                standard: "Finale",
                header: "Finale"
            )
        }
    ]
}
