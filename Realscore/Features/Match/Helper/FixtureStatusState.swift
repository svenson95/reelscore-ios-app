//
//  FixtureStatusState.swift
//  Realscore
//

import Foundation

struct FixtureStatusState {
    let status: String
    let isNotPlayed: Bool
    let isPenalty: Bool
    let isHalftime: Bool
    let isPlaying: Bool
    let isFinished: Bool
}

enum FixtureStatusStateMapper {
    static func state(for status: String) -> FixtureStatusState {
        FixtureStatusState(
            status: status,
            isNotPlayed: notPlayedStatuses.contains(status),
            isPenalty: penaltyStatuses.contains(status),
            isHalftime: halftimeStatuses.contains(status),
            isPlaying: playingStatuses.contains(status),
            isFinished: finishedStatuses.contains(status)
        )
    }

    private static let notPlayedStatuses: Set<String> = [
        "PST", "CANC", "ABD", "AWD", "WO"
    ]

    private static let penaltyStatuses: Set<String> = [
        "PEN"
    ]

    private static let halftimeStatuses: Set<String> = [
        "HT"
    ]

    private static let playingStatuses: Set<String> = [
        "1H", "2H", "ET", "BT", "P", "SUSP", "INT", "LIVE"
    ]

    private static let finishedStatuses: Set<String> = [
        "FT", "AET", "PEN"
    ]
}
