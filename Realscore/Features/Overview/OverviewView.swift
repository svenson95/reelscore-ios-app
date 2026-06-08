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
            selectInitialDayIfNeeded(weekDateCount: viewModel.weekDates.count)
            await viewModel.loadOverviewIfNeeded()
        }
        .refreshable {
            await viewModel.loadOverview()
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

    private func selectInitialDayIfNeeded(weekDateCount count: Int) {
        guard count > 0 else { return }
        guard !didSelectInitialDay else { return }

        let todayIndex = viewModel.todayWeekdayIndex

        if count > todayIndex {
            selectedDayIndex = todayIndex
        } else {
            selectedDayIndex = Constants.firstRealWeekdayIndex
        }

        didSelectInitialDay = true
    }

    private func handleSelectedDayIndexChange(_ newIndex: Int) async {
        guard !isSwitchingWeek else {
            return
        }

        if newIndex == Constants.previousWeekEdgeIndex {
            isSwitchingWeek = true
            defer { isSwitchingWeek = false }
            let didLoad = await viewModel.loadPreviousWeek()
            
            if didLoad {
                selectedDayIndex = Constants.lastRealWeekdayIndex
            }
        }

        if newIndex == Constants.nextWeekEdgeIndex {
            isSwitchingWeek = true
            defer { isSwitchingWeek = false }
            let didLoad = await viewModel.loadNextWeek()
            
            if didLoad {
                selectedDayIndex = Constants.firstRealWeekdayIndex
            }
        }
    }

    private func loadPreviousWeek() async {
        guard !isSwitchingWeek else {
            return
        }

        isSwitchingWeek = true
        defer { isSwitchingWeek = false }
        let didLoad = await viewModel.loadPreviousWeek()
        
        if didLoad {
            selectedDayIndex = Constants.lastRealWeekdayIndex
        }
    }
    
    private func loadNextWeek() async {
        guard !isSwitchingWeek else {
            return
        }

        isSwitchingWeek = true
        defer { isSwitchingWeek = false }
        let didLoad = await viewModel.loadNextWeek()
        
        if didLoad {
            selectedDayIndex = Constants.firstRealWeekdayIndex
        }
    }
}
