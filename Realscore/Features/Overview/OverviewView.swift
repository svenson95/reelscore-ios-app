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
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            content
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
            guard !isSwitchingWeek else { return }
            await viewModel.loadOverview()
        }
    }

    private var content: some View {
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
            .disabled(isSwitchingWeek)
            .onChange(of: selectedDayIndex) { _, newIndex in
                guard isEdgeDayIndex(newIndex) else { return }
                guard !isSwitchingWeek else { return }

                Task {
                    await handleSelectedDayIndexChange(newIndex)
                }
            }
            .onChange(of: viewModel.weekDates.count) { _, newCount in
                guard newCount > 0 else {
                    selectedDayIndex = Constants.firstRealWeekdayIndex
                    return
                }

                if selectedDayIndex >= newCount {
                    selectedDayIndex = max(0, newCount - 1)
                }
            }
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
                guard !isSwitchingWeek else { return }
                await viewModel.loadOverview()
            },
            onRefresh: {
                guard !isSwitchingWeek else { return }
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
        isSwitchingWeek = true
        defer { isSwitchingWeek = false }

        if newIndex == Constants.previousWeekEdgeIndex {
            let didLoad = await viewModel.loadPreviousWeek()

            if didLoad {
                selectedDayIndex = Constants.lastRealWeekdayIndex
            } else {
                selectedDayIndex = Constants.firstRealWeekdayIndex
            }

            return
        }

        if newIndex == Constants.nextWeekEdgeIndex {
            let didLoad = await viewModel.loadNextWeek()

            if didLoad {
                selectedDayIndex = Constants.firstRealWeekdayIndex
            } else {
                selectedDayIndex = Constants.lastRealWeekdayIndex
            }

            return
        }
    }

    private func isEdgeDayIndex(_ index: Int) -> Bool {
        index == Constants.previousWeekEdgeIndex ||
        index == Constants.nextWeekEdgeIndex
    }
}
