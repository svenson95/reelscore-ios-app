//
//  FixtureRowView.swift
//  Realscore
//

import SwiftUI
import UIKit

struct FixtureRowView: View {
    let fixture: Fixture
    
    var status: FixtureStatusShort {
        fixture.fixture.status.short
    }
    
    private let GRAY_STATUS_COLOR = Color.gray.opacity(0.1)
    private let STATUS_PADDING_HORIZONTAL = 2.0
    private let STATUS_PADDING_VERTICAL = 4.0
    private let ROUNDED_BORDERS = 6.0

    var body: some View {
        HStack(spacing: 8) {
            Text(timeText)
                .font(.caption)
                .fontWeight(status.isPlaying ? .semibold : .regular)
                .foregroundStyle(timeTextColor)
                .strikethrough(shouldStrikeThroughTime)
                .monospacedDigit()
                .frame(width: 42, alignment: .center)
                .padding(.horizontal, STATUS_PADDING_HORIZONTAL)
                .padding(.vertical, STATUS_PADDING_VERTICAL)
                .background {
                    if status.isPlaying {
                        RoundedRectangle(cornerRadius: ROUNDED_BORDERS)
                            .fill(.green)
                    }
                    
                    if status.isScheduled {
                        RoundedRectangle(cornerRadius: ROUNDED_BORDERS)
                            .fill(GRAY_STATUS_COLOR)
                    }
                }

            HStack(spacing: 8) {
                teamView(
                    name: fixture.teams.home.name,
                    teamId: fixture.teams.home.id,
                    isHomeTeam: true
                )

                Text(scoreText)
                    .font(.subheadline)
                    .fontWeight(status.isPlaying ? .bold : .regular)
                    .monospacedDigit()
                    .frame(minWidth: 28)
                    .padding(.horizontal, STATUS_PADDING_HORIZONTAL)
                    .padding(.vertical, STATUS_PADDING_VERTICAL)
                    .background {
                        if status.isFinished {
                            RoundedRectangle(cornerRadius: ROUNDED_BORDERS)
                                .fill(GRAY_STATUS_COLOR)
                        }
                    }

                teamView(
                    name: fixture.teams.away.name,
                    teamId: fixture.teams.away.id,
                    isHomeTeam: false
                )
            }
        }
    }

    private func teamView(
        name: String,
        teamId: Int?,
        isHomeTeam: Bool
    ) -> some View {
        HStack(spacing: 8) {
            if isHomeTeam {
                Text(name)
                    .font(.subheadline)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .trailing)

                TeamLogoView(teamId: teamId, size: 16)
            } else {
                TeamLogoView(teamId: teamId, size: 16)

                Text(name)
                    .font(.subheadline)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var scoreText: String {
        if status.isCancelled || status.isAbandoned || status.isNotPlayed {
            return "-"
        }
        
        if status.isScheduled {
            return "vs"
        }

        let home = fixture.goals.home.map(String.init) ?? "?"
        let away = fixture.goals.away.map(String.init) ?? "?"
        return "\(home):\(away)"
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

        return formattedKickoffTime
    }
    
    private var timeTextColor: Color {
        if status.isPlaying {
            return Color(.systemBackground)
        }

        if status.isEnded {
            return .secondary
        }

        return .primary
    }

    private var shouldStrikeThroughTime: Bool {
        return status.isEnded
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
