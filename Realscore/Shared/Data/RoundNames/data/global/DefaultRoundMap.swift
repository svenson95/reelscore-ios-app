//
//  DefaultRoundMap.swift
//  Realscore
//

import Foundation

enum DefaultRoundMap {
    static let values: RoundMap = [
        "Regular Season": { round in
            let number = RoundLabelHelpers.roundNumber(round)

            return RoundLabelTranslation(
                standard: "\(number). Spieltag",
                header: "\(number). Spieltag"
            )
        },

        "League Stage": { round in
            let number = RoundLabelHelpers.roundNumber(round)

            return RoundLabelTranslation(
                standard: "\(number). Spieltag",
                header: "\(number). Spieltag"
            )
        },

        "Group Stage": { round in
            let number = RoundLabelHelpers.roundNumber(round)

            return RoundLabelTranslation(
                standard: "Gruppenphase \(number). Spieltag",
                header: "Gruppenphase #\(number)"
            )
        },

        "Group": { round in
            RoundLabelTranslation(
                standard: RoundLabelHelpers.groupLabel(round),
                header: RoundLabelHelpers.groupLabelHeader(round)
            )
        },

        "League": { round in
            let number = RoundLabelHelpers.roundNumber(round)

            return RoundLabelTranslation(
                standard: RoundLabelHelpers.leagueLabel(round),
                header: "\(number). Spieltag"
            )
        },

        "1st Round": { _ in
            RoundLabelTranslation(
                standard: "1. Runde",
                header: "1. Runde"
            )
        },

        "2nd Round": { _ in
            RoundLabelTranslation(
                standard: "2. Runde",
                header: "2. Runde"
            )
        },

        "3rd Round": { _ in
            RoundLabelTranslation(
                standard: "3. Runde",
                header: "3. Runde"
            )
        },

        "1st Qualifying Round": { _ in
            RoundLabelTranslation(
                standard: "Qualifikation 1. Runde",
                header: "Qualifikation #1"
            )
        },

        "2nd Qualifying Round": { _ in
            RoundLabelTranslation(
                standard: "Qualifikation 2. Runde",
                header: "Qualifikation #2"
            )
        },

        "3rd Qualifying Round": { _ in
            RoundLabelTranslation(
                standard: "Qualifikation 3. Runde",
                header: "Qualifikation #3"
            )
        },

        "Preliminary Round": { _ in
            RoundLabelTranslation(
                standard: "Vorrunde",
                header: "Vorrunde"
            )
        },

        "Play-offs": { _ in
            RoundLabelTranslation(
                standard: "Ausscheidungsspiele",
                header: "Ausscheidungsspiele"
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
        },

        "Friendly International": { _ in
            RoundLabelTranslation(
                standard: "",
                header: ""
            )
        }
    ]
}
