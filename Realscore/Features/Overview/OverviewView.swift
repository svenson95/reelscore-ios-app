//
//  OverviewView.swift
//  Realscore
//

import SwiftUI

struct OverviewView: View {
    @StateObject private var viewModel = OverviewViewModel()
    
    @State private var selectedDayIndex = 1
    @State private var didSelectInitialDay = false
    @State private var isSwitchingWeek = false

    var body: some View {
        VStack(spacing: 0) {
            if !viewModel.weekDates.isEmpty {
                weekdayPicker
            }

            TabView(selection: $selectedDayIndex) {
                ForEach(viewModel.weekDates.indices, id: \.self) { index in
                    fixturesList(for: index)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: selectedDayIndex) { _, newIndex in
                Task {
                    await handleSelectedDayIndexChange(newIndex)
                }
            }
        }
        .overlay {
            if viewModel.isLoading && !viewModel.didLoadInitialData {
                LoadingView()
            }
        }
        .navigationTitle("Überblick")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadOverviewIfNeeded()
        }
        .refreshable {
            await viewModel.loadOverview()
        }
        .onChange(of: viewModel.weekDates.count) { _, count in
            guard count > 0 else { return }
            guard !didSelectInitialDay else { return }

            let todayIndex = viewModel.todayWeekdayIndex + 1

            if count > todayIndex {
                selectedDayIndex = todayIndex
            } else {
                selectedDayIndex = 1
            }

            didSelectInitialDay = true
        }
    }

    private var weekdayPicker: some View {
        HStack(spacing: 4) {
            ForEach(visibleWeekdayIndices, id: \.self) { index in
                let day = viewModel.dayItem(for: index)

                Button {
                    selectedDayIndex = index
                } label: {
                    VStack(spacing: 3) {
                        Text(day.weekdayLabel)
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .lineLimit(1)

                        Text(day.dayLabel)
                            .font(.caption2)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        selectedDayIndex == index
                        ? Color.accentColor.opacity(0.18)
                        : Color.clear
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(.bar)
    }

    @ViewBuilder
    private func fixturesList(for dayIndex: Int) -> some View {
        let fixtures = viewModel.fixturesForDay(at: dayIndex)
        let groupedFixtures = groupedFixtures(fixtures)

        List {
            if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage) {
                    Task {
                        await viewModel.loadOverview()
                    }
                }
            }

            if fixtures.isEmpty && !viewModel.isLoading && viewModel.didLoadInitialData {
                EmptyStateView(
                    title: "Keine Spiele",
                    systemImage: "calendar"
                )
            }

            ForEach(groupedFixtures) { group in
                Section {
                    ForEach(group.fixtures) { fixture in
                        NavigationLink {
                            MatchView(fixture: fixture)
                        } label: {
                            FixtureRowView(fixture: fixture)
                        }
                    }
                } header: {
                    FixtureSectionHeaderView(group: group)
                }
            }
        }
        .refreshable {
            await viewModel.loadOverview()
        }
    }
    
    struct FixtureSectionHeaderView: View {
        let group: FixtureSectionGroup

        var body: some View {
            HStack(spacing: 12) {
                if let logo = group.competitionLogo,
                   let url = URL(string: logo) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Color.clear
                    }
                    .frame(width: 24, height: 24)
                }

                Text(group.competition)
                    .font(.default)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                Spacer()

                Text(group.round)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .textCase(nil)
        }
    }

    private func groupedFixtures(_ fixtures: [Fixture]) -> [FixtureSectionGroup] {
        let groups = Dictionary(grouping: fixtures) { fixture in
            FixtureGroupKey(
                competition: fixture.league.name,
                round: fixture.league.round ?? "-"
            )
        }

        return groups
            .map { key, fixtures in
                FixtureSectionGroup(
                    competition: key.competition,
                    competitionLogo: fixtures.first?.league.logo,
                    round: key.round,
                    fixtures: fixtures
                )
            }
            .sorted {
                if $0.competition == $1.competition {
                    return $0.round < $1.round
                }

                return $0.competition < $1.competition
            }
    }
    
    private func handleSelectedDayIndexChange(_ index: Int) async {
        guard !isSwitchingWeek else { return }
        guard viewModel.weekDates.count >= 9 else { return }

        let previousSundayIndex = 0
        let nextMondayIndex = viewModel.weekDates.count - 1

        if index == previousSundayIndex {
            isSwitchingWeek = true

            await viewModel.loadPreviousWeek()

            // Neue Woche mit Edge-Days:
            // index 7 = Sonntag der sichtbaren Arbeitswoche
            selectedDayIndex = 7

            isSwitchingWeek = false
        } else if index == nextMondayIndex {
            isSwitchingWeek = true

            await viewModel.loadNextWeek()

            // Neue Woche:
            // index 1 = Montag
            selectedDayIndex = 1

            isSwitchingWeek = false
        }
    }
    
    private var visibleWeekdayIndices: [Int] {
        guard viewModel.weekDates.count >= 9 else {
            return Array(viewModel.weekDates.indices)
        }

        return Array(1...(viewModel.weekDates.count - 2))
    }
}
