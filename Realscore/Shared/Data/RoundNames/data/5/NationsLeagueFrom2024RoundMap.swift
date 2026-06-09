//
//  NationsLeagueFrom2024RoundMap.swift
//  Realscore
//

import Foundation

enum NationsLeagueFrom2024RoundMap {

    static let values: RoundMapOverride = [
        "League": { round in
            RoundLabelTranslation(
                standard: groupLabel(round),
                header: groupLabelHeader(round)
            )
        },

        "Play-offs A/B": { _ in
            RoundLabelTranslation(
                standard: "Play-offs A/B",
                header: "Play-offs A/B"
            )
        },

        "Play-offs B/C": { _ in
            RoundLabelTranslation(
                standard: "Play-offs B/C",
                header: "Play-offs B/C"
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

        "3rd Place Final": { _ in
            RoundLabelTranslation(
                standard: "Spiel um 3. Platz",
                header: "3. Platz"
            )
        },

        "Final": { _ in
            RoundLabelTranslation(
                standard: "Finale",
                header: "Finale"
            )
        },

        "Play-offs C/D": { _ in
            RoundLabelTranslation(
                standard: "Play-offs C/D",
                header: "Play-offs C/D"
            )
        }
    ]

    private static func groupLabel(_ value: CompetitionRound) -> CompetitionRound {
        guard let spacerRange = value.range(of: "-") else {
            return value
        }

        let roundStartIndex = value.index(spacerRange.lowerBound, offsetBy: 2, limitedBy: value.endIndex) ?? value.endIndex
        let groupStartIndex = value.index(spacerRange.lowerBound, offsetBy: -2, limitedBy: value.startIndex) ?? value.startIndex

        let round = String(value[roundStartIndex...])
        let group = String(value[groupStartIndex..<spacerRange.lowerBound])

        return "\(round). Spieltag - Gruppe \(group)"
    }

    private static func groupLabelHeader(_ value: CompetitionRound) -> CompetitionRound {
        guard let spacerRange = value.range(of: "-") else {
            return value
        }

        let roundStartIndex = value.index(spacerRange.lowerBound, offsetBy: 2, limitedBy: value.endIndex) ?? value.endIndex
        let groupStartIndex = value.index(spacerRange.lowerBound, offsetBy: -2, limitedBy: value.startIndex) ?? value.startIndex

        let round = String(value[roundStartIndex...])
        let group = String(value[groupStartIndex..<spacerRange.lowerBound])

        return "#\(round) Gruppe \(group)"
    }
}
