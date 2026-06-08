//
//  OverviewView.swift
//  Realscore
//

import SwiftUI

struct OverviewView: View {
    @StateObject private var viewModel = OverviewViewModel()
    @StateObject private var selectedDateStore = SelectedDateStore()

    @State private var didSelectInitialDay = false
    @State private var isSwitchingWeek = false
    @State private var pendingTabCommitTask: Task<Void, Never>?
    @State private var tabSelectionIndex = Constants.firstRealWeekdayIndex

    private var selectedDateText: String {
        selectedDateStore.selectedDate.dayMonthYearString
    }

    private var selectedDayBinding: Binding<Int> {
        Binding(
            get: {
                tabSelectionIndex
            },
            set: { newIndex in
                handleSelectedDayBindingChange(newIndex)
            }
        )
    }
    
    private var tabViewID: String {
        viewModel.weekDates.first?.apiDateString ?? "empty"
    }
    
    private var isShowingTodayView: Bool {
        selectedDateStore.selectedDate.isSameDay(as: Date())
    }

    var body: some View {
        content
            .background(Color(.systemGroupedBackground))
            .scrollContentBackground(.hidden)
            .overlay {
                if viewModel.isLoading && !viewModel.didLoadInitialData {
                    LoadingView()
                }
            }
            .navigationTitle("Überblick")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // TODO: DatePicker öffnen
                    } label: {
                        Text(selectedDateText)
                            .font(.subheadline.weight(.semibold))
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    if !isShowingTodayView {
                        Button("Heute") {
                            Task {
                                await selectToday()
                            }
                        }
                    }
                }
            }
            .task {
                selectInitialDayIfNeeded(weekDateCount: viewModel.weekDates.count)
                await viewModel.loadOverviewIfNeeded()
            }
            .refreshable {
                guard !isSwitchingWeek else { return }
                await viewModel.loadOverview()
            }
            .onDisappear {
                pendingTabCommitTask?.cancel()
                pendingTabCommitTask = nil
            }
    }

    private var content: some View {
        VStack(spacing: 0) {
            if !viewModel.weekDates.isEmpty {
                OverviewWeekdayPickerView(
                    weekDates: viewModel.weekDates,
                    selectedDayIndex: selectedDayBinding
                )
            }

            TabView(selection: selectedDayBinding) {
                ForEach(viewModel.weekDates.indices, id: \.self) { index in
                    fixturesList(for: index)
                        .tag(index)
                }
            }
            .id(tabViewID)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .disabled(isSwitchingWeek)
            .onChange(of: viewModel.weekDates) { _, newWeekDates in
                handleWeekDatesChange(newWeekDates)
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

    private func handleSelectedDayBindingChange(_ newIndex: Int) {
        guard viewModel.weekDates.indices.contains(newIndex) else {
            return
        }

        guard !isSwitchingWeek else {
            return
        }

        tabSelectionIndex = newIndex

        pendingTabCommitTask?.cancel()

        pendingTabCommitTask = Task { @MainActor in
            await waitAndCommitTabSelection(for: newIndex)
        }
    }
    
    @MainActor
    private func waitAndCommitTabSelection(for index: Int) async {
        do {
            try await Task.sleep(for: .milliseconds(350))
        } catch {
            return
        }

        guard !Task.isCancelled else {
            return
        }

        guard tabSelectionIndex == index else {
            return
        }

        guard viewModel.weekDates.indices.contains(index) else {
            return
        }

        guard !isSwitchingWeek else {
            return
        }

        pendingTabCommitTask = nil

        if isEdgeDayIndex(index) {
            await handleSelectedEdgeDayIndexChange(index)
            return
        }

        commitSelection(at: index)
    }
    
    @MainActor
    private func commitSelection(at index: Int) {
        guard viewModel.weekDates.indices.contains(index) else {
            return
        }

        tabSelectionIndex = index

        selectedDateStore.selectDay(
            at: index,
            in: viewModel.weekDates
        )
    }

    private func selectInitialDayIfNeeded(weekDateCount count: Int) {
        guard count > 0 else { return }
        guard !didSelectInitialDay else { return }

        let todayIndex = viewModel.todayWeekdayIndex

        let initialIndex: Int

        if viewModel.weekDates.indices.contains(todayIndex) {
            initialIndex = todayIndex
        } else {
            initialIndex = Constants.firstRealWeekdayIndex
        }

        commitSelection(at: initialIndex)

        didSelectInitialDay = true
    }

    private func selectToday() async {
        guard !isSwitchingWeek else { return }

        pendingTabCommitTask?.cancel()
        pendingTabCommitTask = nil

        let today = Date()

        if let todayIndex = viewModel.weekDates.firstIndex(where: {
            Calendar.current.isDate($0, inSameDayAs: today)
        }) {
            if !isEdgeDayIndex(todayIndex) {
                commitSelection(at: todayIndex)
                return
            }
        }

        isSwitchingWeek = true
        defer { isSwitchingWeek = false }

        let didLoad = await viewModel.loadCurrentWeek()

        guard didLoad else {
            return
        }

        await Task.yield()

        guard let todayIndex = viewModel.weekDates.firstIndex(where: {
            Calendar.current.isDate($0, inSameDayAs: today)
        }) else {
            commitSelection(at: Constants.firstRealWeekdayIndex)
            return
        }

        if isEdgeDayIndex(todayIndex) {
            commitSelection(at: Constants.firstRealWeekdayIndex)
            return
        }

        commitSelection(at: todayIndex)
    }

    private func handleSelectedEdgeDayIndexChange(_ newIndex: Int) async {
        guard !isSwitchingWeek else { return }

        isSwitchingWeek = true
        defer { isSwitchingWeek = false }

        if newIndex == Constants.previousWeekEdgeIndex {
            await switchToPreviousWeek()
            return
        }

        if newIndex == Constants.nextWeekEdgeIndex {
            await switchToNextWeek()
            return
        }
    }

    private func switchToPreviousWeek() async {
        let fallbackIndex = selectedDateStore.selectedDayIndex

        let didLoad = await viewModel.loadPreviousWeek()

        guard didLoad else {
            commitSelection(at: fallbackIndex)
            return
        }

        await Task.yield()

        commitSelection(at: Constants.lastRealWeekdayIndex)
    }

    private func switchToNextWeek() async {
        let fallbackIndex = selectedDateStore.selectedDayIndex

        let didLoad = await viewModel.loadNextWeek()

        guard didLoad else {
            commitSelection(at: fallbackIndex)
            return
        }

        await Task.yield()

        commitSelection(at: Constants.firstRealWeekdayIndex)
    }

    private func handleWeekDatesChange(_ weekDates: [Date]) {
        guard !isSwitchingWeek else {
            return
        }

        guard !weekDates.isEmpty else {
            tabSelectionIndex = Constants.firstRealWeekdayIndex

            selectedDateStore.reset(
                fallbackIndex: Constants.firstRealWeekdayIndex
            )

            return
        }

        if !weekDates.indices.contains(tabSelectionIndex) {
            tabSelectionIndex = max(0, weekDates.count - 1)
        }

        selectedDateStore.clampSelectionIfNeeded(in: weekDates)
    }

    private func isEdgeDayIndex(_ index: Int) -> Bool {
        index == Constants.previousWeekEdgeIndex ||
        index == Constants.nextWeekEdgeIndex
    }
}
