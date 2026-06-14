//
//  MatchHeaderView.swift
//  Realscore
//

import SwiftUI

struct MatchHeaderView: View {
    let fixture: Fixture

    @StateObject private var venueImageLoader = VenueImageLoader()

    private var venueId: VenueId {
        VenueIds.mappedVenueId(forTeamId: fixture.teams.home.id)
            ?? VenueIds.DEFAULT_VALUE
    }

    var body: some View {
        headerContent
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppLayout.medium)
            .foregroundColor(.primary)
            .background {
                venueBackground
            }
            .clipShape(RoundedRectangle(cornerRadius: AppLayout.cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: AppLayout.cornerRadius, style: .continuous)
                    .stroke(.primary.opacity(0.08), lineWidth: 1)
            }
            .task(id: venueId) {
                venueImageLoader.loadVenueImage(for: venueId)
            }
    }

    private var headerContent: some View {
        HStack(spacing: 6) {
            Spacer()

            teamSection(for: fixture.teams.home)

            resultColumn

            teamSection(for: fixture.teams.away)

            Spacer()
        }
    }

    private var venueBackground: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)

            if let image = venueImageLoader.image,
               venueImageLoader.hasValidVenueBackground {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .opacity(venueImageLoader.isLoaded ? 0.2 : 0)
                    .transition(.opacity)
            }
        }
        .clipped()
        .animation(
            .easeInOut(duration: 0.15),
            value: venueImageLoader.isLoaded
        )
        .allowsHitTesting(false)
    }

    var teamsString: String {
        fixture.teams.home.name.teamName() + " - " + fixture.teams.away.name.teamName()
    }

    private var resultColumn: some View {
        VStack(spacing: 8) {
            MatchStatusLabelView(fixture: fixture)

            ResultLabelView(
                fixture: fixture,
                showNotPlayedText: true
            )
            .multilineTextAlignment(.center)
        }
        .frame(minWidth: 50)
    }

    private func teamSection(for team: FixtureTeam) -> some View {
        VStack {
            TeamLogoView(teamId: team.id, size: 64)
                .frame(minHeight: 64)

            Text(team.name.teamName())
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}
