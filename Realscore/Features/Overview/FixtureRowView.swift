//
//  FixtureRowView.swift
//  Realscore
//

import SwiftUI

struct FixtureRowView: View {
    let fixture: Fixture

    var body: some View {
        HStack(spacing: 12) {
            Text(timeText)
                .font(.caption)
                .fontWeight(isPlaying ? .semibold : .regular)
                .foregroundStyle(isPlaying ? .white : .secondary)
                .strikethrough(shouldStrikeThroughTime)
                .frame(width: 42, alignment: .center)
                .padding(.vertical, 3)
                .background {
                    if isPlaying {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(.green)
                    }
                }

            HStack(spacing: 0) {
                teamView(
                    name: fixture.teams.home.name,
                    logoURL: fixture.teams.home.logo,
                    isHomeTeam: true
                )

                Text(scoreText)
                    .font(.headline)
                    .monospacedDigit()
                    .frame(minWidth: 44)

                teamView(
                    name: fixture.teams.away.name,
                    logoURL: fixture.teams.away.logo,
                    isHomeTeam: false
                )
            }
        }
    }

    private func teamView(
        name: String,
        logoURL: String?,
        isHomeTeam: Bool
    ) -> some View {
        HStack(spacing: 8) {
            if isHomeTeam {
                Text(name)
                    .font(.subheadline)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .trailing)

                teamLogo(logoURL)
            } else {
                teamLogo(logoURL)

                Text(name)
                    .font(.subheadline)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func teamLogo(_ logoURL: String?) -> some View {
        AsyncImage(url: logoURL.flatMap(URL.init(string:))) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            Image(systemName: "shield")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(width: 16, height: 16)
    }

    private var scoreText: String {
        let home = fixture.goals.home.map(String.init) ?? "-"
        let away = fixture.goals.away.map(String.init) ?? "-"
        return "\(home):\(away)"
    }

    private var isPenalty: Bool {
        fixture.fixture.status.short == "PEN"
    }

    private var isHalftime: Bool {
        fixture.fixture.status.short == "HT"
    }

    private var isPlaying: Bool {
        ["1H", "2H", "ET", "BT", "P", "INT"].contains(fixture.fixture.status.short) || isHalftime || isPenalty
    }

    private var isFinished: Bool {
        ["FT", "AET", "PEN"].contains(fixture.fixture.status.short)
    }
    
    private var isoDateFormatter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        return formatter
    }
    
    private var timeText: String {
        let status = fixture.fixture.status.short

        if isPenalty {
            return "Elfm."
        }

        if isHalftime {
            return "HZ"
        }

        if isPlaying {
            if status == "INT" {
                return "Unt."
            }

            let elapsed = fixture.fixture.status.elapsed ?? 0
            let extra = fixture.fixture.status.extra ?? 0

            return "\(elapsed + extra)'"
        }

        return formattedKickoffTime
    }

    private var shouldStrikeThroughTime: Bool {
        isFinished
    }

    private var formattedKickoffTime: String {
        guard let date = parseFixtureDate(fixture.fixture.date) else {
            return ""
        }

        return kickoffTimeFormatter.string(from: date)
    }

    private func parseFixtureDate(_ value: String) -> Date? {
        let formatterWithFractionalSeconds = ISO8601DateFormatter()
        formatterWithFractionalSeconds.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]

        if let date = formatterWithFractionalSeconds.date(from: value) {
            return date
        }

        let formatterWithoutFractionalSeconds = ISO8601DateFormatter()
        formatterWithoutFractionalSeconds.formatOptions = [
            .withInternetDateTime
        ]

        return formatterWithoutFractionalSeconds.date(from: value)
    }

    private var kickoffTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "de_DE")
        formatter.timeZone = TimeZone(identifier: "Europe/Berlin")
        return formatter
    }
}
