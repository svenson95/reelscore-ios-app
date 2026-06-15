//
//  FixtureRowTextProvider.swift
//  Realscore
//

import Foundation

enum FixtureRowTextProvider {
    static func score(for fixture: Fixture) -> String {
        let status = fixture.fixture.status.short

        if status.isCancelled || status.isAbandoned || status.isNotPlayed {
            return "-"
        }

        if status.isScheduled {
            return "vs"
        }

        let home = fixture.goals.home.map(String.init) ?? "?"
        let away = fixture.goals.away.map(String.init) ?? "?"

        return "\(home)\u{2009}:\u{2009}\(away)"
    }

    static func time(for fixture: Fixture) -> String {
        let status = fixture.fixture.status.short

        if status.isHalftime {
            return "HZ"
        }

        if status.isPlaying {
            if status == "INT" {
                return "Unt."
            }

            if status == "P" {
                return "Elfm."
            }

            let elapsed = fixture.fixture.status.elapsed ?? 0
            let extra = fixture.fixture.status.extra ?? 0

            return "\(elapsed + extra)'"
        }

        return kickoffTime(for: fixture)
    }

    private static func kickoffTime(for fixture: Fixture) -> String {
        guard let date = FixtureDateParser.parse(fixture.fixture.date) else {
            return ""
        }

        return FixtureDateParser.kickoffTimeFormatter.string(from: date)
    }
}
