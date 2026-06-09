//
//  RoundLabelHelpers.swift
//  Realscore
//

import Foundation

enum RoundLabelHelpers {
    static func roundNumber(_ round: String) -> String {
        guard let dashIndex = round.lastIndex(of: "-") else {
            return round
        }

        let startIndex = round.index(dashIndex, offsetBy: 2, limitedBy: round.endIndex) ?? round.endIndex
        return String(round[startIndex...])
    }

    static func leagueLabel(_ value: String) -> String {
        guard let dashIndex = value.firstIndex(of: "-") else {
            return value
        }

        let roundStartIndex = value.index(dashIndex, offsetBy: 2, limitedBy: value.endIndex) ?? value.endIndex
        let groupStartIndex = value.index(value.startIndex, offsetBy: "League".count, limitedBy: value.endIndex) ?? value.startIndex
        let groupEndIndex = value.index(dashIndex, offsetBy: -1, limitedBy: value.startIndex) ?? dashIndex

        let round = String(value[roundStartIndex...])
        let group = String(value[groupStartIndex..<groupEndIndex])

        return "Liga \(group) - \(round). Spieltag"
    }

    static func groupLabel(_ value: String) -> String {
        guard let dashIndex = value.firstIndex(of: "-") else {
            return value
        }

        let roundStartIndex = value.index(dashIndex, offsetBy: 2, limitedBy: value.endIndex) ?? value.endIndex
        let groupStartIndex = value.index(value.startIndex, offsetBy: "Group".count, limitedBy: value.endIndex) ?? value.startIndex
        let groupEndIndex = value.index(dashIndex, offsetBy: -1, limitedBy: value.startIndex) ?? dashIndex

        let round = String(value[roundStartIndex...])
        let group = String(value[groupStartIndex..<groupEndIndex])

        return "Gruppe \(group) - \(round). Spieltag"
    }

    static func groupLabelHeader(_ value: String) -> String {
        guard let dashIndex = value.firstIndex(of: "-") else {
            return value
        }

        let roundStartIndex = value.index(dashIndex, offsetBy: 2, limitedBy: value.endIndex) ?? value.endIndex
        let groupStartIndex = value.index(value.startIndex, offsetBy: "Group".count, limitedBy: value.endIndex) ?? value.startIndex
        let groupEndIndex = value.index(dashIndex, offsetBy: -1, limitedBy: value.startIndex) ?? dashIndex

        let round = String(value[roundStartIndex...])
        let group = String(value[groupStartIndex..<groupEndIndex])

        return "#\(round) Gruppe \(group)"
    }
}
