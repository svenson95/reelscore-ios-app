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
    @State private var isProgrammaticDaySelection = false

    var body: some View {
        VStack(spacing: 0) {
            if !viewModel.weekDates.isEmpty {
                OverviewWeekdayPickerView(
                    weekDates: viewModel.weekDates,
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
    
    private var weekdayPicker: some View {
        OverviewWeekdayPickerView(
            weekDates: viewModel.weekDates,
            selectedDayIndex: $selectedDayIndex
        )
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
        guard !isSwitchingWeek else {
            return
        }

        if index == 0 {
            await loadPreviousWeek()
        } else if index == viewModel.weekDates.count - 1 {
            await loadNextWeek()
        }
    }

    private func loadPreviousWeek() async {
        guard !isSwitchingWeek else {
            return
        }

        isSwitchingWeek = true

        await viewModel.loadPreviousWeek()
        selectedDayIndex = 7

        isSwitchingWeek = false
    }
    
    private func loadNextWeek() async {
        guard !isSwitchingWeek else {
            return
        }

        isSwitchingWeek = true

        await viewModel.loadNextWeek()
        selectedDayIndex = 1

        isSwitchingWeek = false
    }
}
