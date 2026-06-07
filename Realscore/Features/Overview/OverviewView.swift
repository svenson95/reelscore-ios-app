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
                OverviewWeekdayPickerView(
                    items: weekdayPickerItems,
                    selectedDayIndex: $selectedDayIndex
                )
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
            selectInitialDayIfNeeded(weekDateCount: count)
        }
    }

    private func fixturesList(for dayIndex: Int) -> some View {
        let fixtures = viewModel.fixturesForDay(at: dayIndex)

        return OverviewFixturesListView(
            fixtures: fixtures,
            groupedFixtures: fixtures.groupedByCompetitionAndRound(),
            errorMessage: viewModel.errorMessage,
            isLoading: viewModel.isLoading,
            didLoadInitialData: viewModel.didLoadInitialData,
            onRetry: {
                await viewModel.loadOverview()
            },
            onRefresh: {
                await viewModel.loadOverview()
            }
        )
    }

    private var weekdayPickerItems: [OverviewWeekdayPickerItem] {
        visibleWeekdayIndices.map { index in
            let day = viewModel.dayItem(for: index)

            return OverviewWeekdayPickerItem(
                index: index,
                weekdayLabel: day.weekdayLabel,
                dayLabel: day.dayLabel
            )
        }
    }

    private var visibleWeekdayIndices: [Int] {
        guard viewModel.weekDates.count >= 9 else {
            return Array(viewModel.weekDates.indices)
        }

        return Array(1...(viewModel.weekDates.count - 2))
    }

    private func selectInitialDayIfNeeded(weekDateCount count: Int) {
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

    private func handleSelectedDayIndexChange(_ index: Int) async {
        guard !isSwitchingWeek else { return }
        guard viewModel.weekDates.count >= 9 else { return }

        let previousSundayIndex = 0
        let nextMondayIndex = viewModel.weekDates.count - 1

        if index == previousSundayIndex {
            await switchToPreviousWeek()
        } else if index == nextMondayIndex {
            await switchToNextWeek()
        }
    }

    private func switchToPreviousWeek() async {
        isSwitchingWeek = true

        await viewModel.loadPreviousWeek()
        selectedDayIndex = 7

        isSwitchingWeek = false
    }

    private func switchToNextWeek() async {
        isSwitchingWeek = true

        await viewModel.loadNextWeek()
        selectedDayIndex = 1

        isSwitchingWeek = false
    }
}
