//
//  Season+Data.swift
//  Realscore
//

import Foundation

public enum SeasonData {

    public static let competitionsWithMultipleRoundsInSomeSeasons:
        [CompetitionId] = [
            2, 3,
        ]

    public static let competitionsWithMultipleGroups: Set<CompetitionId> = [
        1, 4, 5, 31, 32,
    ]

    public static let competitionsWithoutStandings: Set<CompetitionId> = [
        10, 48, 81, 137, 528, 529, 531,
    ]

    public static let competitionsWithOnlyOneFixture: Set<CompetitionId> = [
        528, 529, 531,
    ]

    public static let koPhaseRounds: Set<CompetitionRound> = [
        "Round of 16",
        "Quarter-finals",
        "Final",
        "Semi-finals",
    ]

    public static let seasons: Set<CompetitionSeason> = [
        2023, 2024, 2025, 2026,
    ]

    public static let fixedSeasonByCompetition:
        [CompetitionId: CompetitionSeason] = [
            31: 2026,  // World Cup Qualifiers Concaf
            32: 2024,  // World Cup Qualifiers Europe
            1: 2026,  // World Cup
            4: 2024,  // Euro Cup
            5: 2024,  // UEFA Nations League
            10: 2026,  // Friendlies
            253: 2026,  // Friendlies
        ]

    public static func seasonStart(
        from date: Date,
        calendar: Calendar = .current
    ) -> Date? {
        let year = calendar.component(.year, from: date)

        return calendar.date(
            from: DateComponents(
                year: year,
                month: 8,
                day: 1
            )
        )
    }
}
