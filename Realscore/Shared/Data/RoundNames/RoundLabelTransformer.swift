//
//  RoundLabelTransformer.swift
//  Realscore
//

import Foundation

enum RoundLabelTransformer {

    static func transform(
        _ round: String,
        context: RoundLabelContext,
        option: RoundLabelType = .standard
    ) -> String {
        let translation = roundTranslation(for: round, context: context)

        switch option {
        case .standard:
            return translation.standard
        case .header:
            return translation.header
        }
    }

    private static func roundTranslation(
        for round: String,
        context: RoundLabelContext
    ) -> RoundLabelTranslation {
        let normalizedRound = normalize(round)
        let map = roundMap(for: context)

        if let mappedRound = map[normalizedRound] {
            return mappedRound(normalizedRound)
        }

        if let defaultRound = defaultTranslation(for: normalizedRound) {
            return defaultRound
        }

        return RoundLabelTranslation(
            standard: normalizedRound,
            header: normalizedRound
        )
    }

    private static func defaultTranslation(for round: String) -> RoundLabelTranslation? {
        if let exactMatch = DefaultRoundMap.values[round] {
            return exactMatch(round)
        }

        let matchingKey = DefaultRoundMap.values.keys
            .sorted { $0.count > $1.count }
            .first { key in
                round == key ||
                round.hasPrefix("\(key) -") ||
                round.hasPrefix("\(key) ")
            }

        guard let matchingKey,
              let translation = DefaultRoundMap.values[matchingKey]
        else {
            return nil
        }

        return translation(round)
    }

    private static func roundMap(for context: RoundLabelContext) -> RoundMapOverride {
        RoundMapRules.values
            .filter {
                $0.id == context.id &&
                context.season >= $0.fromSeason
            }
            .sorted { $0.fromSeason > $1.fromSeason }
            .first?
            .map ?? [:]
    }

    private static func normalize(_ value: String) -> String {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "–", with: "-")
            .replacingOccurrences(of: "—", with: "-")
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
    }
}
