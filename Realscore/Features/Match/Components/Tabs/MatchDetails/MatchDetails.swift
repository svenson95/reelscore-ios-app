//
//  MatchDetails.swift
//  Realscore
//

import SwiftUI

struct MatchDetails: View {
    let fixture: Fixture

    private var round: String {
        fixture.league.round?.roundLabel(
            competitionId: fixture.league.id,
            season: fixture.league.season ?? -1
        ) ?? "-"
    }

    var body: some View {
        VStack(spacing: 14) {
            detailsSection

            PlaceholderSection(
                title: "Tabellen",
                placeholder: "Tabelle ..."
            )

            PlaceholderSection(
                title: "Aktuelle Form",
                placeholder: "Formkurve ..."
            )

            PlaceholderSection(
                title: "Letzte Partien",
                placeholder: "Letzte Partien ..."
            )
        }
    }

    private var detailsSection: some View {
        MatchDetailsSection(title: "Details") {
            VStack(spacing: 0) {
                MatchDetailRow(
                    title: "Spieltag",
                    value: round
                )

                Divider()

                MatchDetailRow(
                    title: "Stadion",
                    value: fixture.fixture.venue.name ?? "-"
                )

                Divider()

                MatchDetailRow(
                    title: "Stadt",
                    value: fixture.fixture.venue.city ?? "-"
                )

                Divider()

                MatchDetailRow(
                    title: "Schiedsrichter",
                    value: fixture.fixture.referee ?? "-"
                )
            }
        }
    }
}

private struct MatchDetailsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)

            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppLayout.large)
        .background {
            RoundedRectangle(cornerRadius: AppLayout.cornerRadius, style: .continuous)
                .fill(.secondary.opacity(0.12))
        }
    }
}

private struct MatchDetailRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: AppLayout.large) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 105, alignment: .leading)

            Text(value.isEmpty ? "-" : value)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.vertical, AppLayout.medium)
    }
}

private struct PlaceholderSection: View {
    let title: String
    let placeholder: String

    var body: some View {
        MatchDetailsSection(title: title) {
            Text(placeholder)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, AppLayout.small)
        }
    }
}
