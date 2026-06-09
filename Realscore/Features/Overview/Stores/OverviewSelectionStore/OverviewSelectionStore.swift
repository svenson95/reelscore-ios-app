//
//  OverviewSelectionStore.swift
//  Realscore
//

import SwiftUI
import Combine

@MainActor
final class OverviewSelectionStore: ObservableObject {
    @Published private(set) var selectedDate = WeekDateHelper.day(for: Date())
    @Published private(set) var selectedDayIndex = Constants.firstRealWeekdayIndex
    @Published private(set) var isSwitchingWeek = false

    @Published var tabIndex = Constants.firstRealWeekdayIndex

    private var didSelectInitialDay = false
    private var pendingTask: Task<Void, Never>?

    private let navigator: OverviewSelectionNavigator

    init(navigator: OverviewSelectionNavigator = OverviewSelectionNavigator()) { // Call to main actor-isolated initializer 'init()' in a synchronous nonisolated context
        self.navigator = navigator
    }

    var selectedDateText: String {
        selectedDate.dayMonthYearString
    }

    var isTodaySelected: Bool {
        Calendar.appCalendar.isDate(selectedDate, inSameDayAs: Date())
    }

    func dayBinding(viewModel: OverviewViewModel) -> Binding<Int> {
        Binding(
            get: { self.tabIndex },
            set: { self.handleTabChange($0, viewModel: viewModel) }
        )
    }

    func cancelPendingTask() {
        pendingTask?.cancel()
        pendingTask = nil
    }

    func selectInitialDayIfNeeded(viewModel: OverviewViewModel) {
        guard !didSelectInitialDay else { return }
        guard !viewModel.weekDates.isEmpty else { return }

        let index = OverviewSelectionRules.safeInitialIndex(
            todayWeekdayIndex: viewModel.todayWeekdayIndex,
            weekDates: viewModel.weekDates
        )

        commit(index, in: viewModel.weekDates)
        didSelectInitialDay = true
    }

    func selectToday(viewModel: OverviewViewModel) async {
        await select(
            Date(),
            viewModel: viewModel,
            loadWeek: {
                await viewModel.loadCurrentWeek()
            }
        )
    }

    func selectDate(
        _ date: Date,
        viewModel: OverviewViewModel
    ) async {
        let normalizedDate = WeekDateHelper.day(for: date)

        await select(
            normalizedDate,
            viewModel: viewModel,
            loadWeek: {
                await viewModel.loadWeek(containing: normalizedDate)
            }
        )
    }

    func handleWeekDatesChange(_ weekDates: [Date]) {
        guard !isSwitchingWeek else { return }

        guard !weekDates.isEmpty else {
            reset()
            return
        }

        let index = navigator.indexForChangedWeekDates(
            selectedDate: selectedDate,
            tabIndex: tabIndex,
            weekDates: weekDates
        )

        commit(index, in: weekDates)
    }

    private func handleTabChange(
        _ index: Int,
        viewModel: OverviewViewModel
    ) {
        guard viewModel.weekDates.indices.contains(index) else { return }
        guard !isSwitchingWeek else { return }

        cancelPendingTask()
        commit(index, in: viewModel.weekDates)

        guard OverviewSelectionRules.isEdgeIndex(index) else { return }

        pendingTask = Task { @MainActor in
            await switchWeek(from: index, viewModel: viewModel)
            pendingTask = nil
        }
    }

    private func select(
        _ date: Date,
        viewModel: OverviewViewModel,
        loadWeek: @escaping () async -> Bool
    ) async {
        guard !isSwitchingWeek else { return }

        cancelPendingTask()

        let normalizedDate = WeekDateHelper.day(for: date)
        selectedDate = normalizedDate

        if let index = navigator.indexForVisibleDate(
            normalizedDate,
            weekDates: viewModel.weekDates
        ) {
            commit(index, in: viewModel.weekDates)
            return
        }

        await loadAndCommitDate(
            normalizedDate,
            viewModel: viewModel,
            loadWeek: loadWeek
        )
    }

    private func loadAndCommitDate(
        _ date: Date,
        viewModel: OverviewViewModel,
        loadWeek: @escaping () async -> Bool
    ) async {
        guard !isSwitchingWeek else { return }

        isSwitchingWeek = true
        defer { isSwitchingWeek = false }

        let didLoad = await loadWeek()
        guard didLoad else { return }

        let index = navigator.indexForLoadedDate(
            date,
            weekDates: viewModel.weekDates
        )

        commit(index, in: viewModel.weekDates)
    }

    private func switchWeek(
        from edgeIndex: Int,
        viewModel: OverviewViewModel
    ) async {
        guard !isSwitchingWeek else { return }

        isSwitchingWeek = true
        defer { isSwitchingWeek = false }

        let fallbackIndex = selectedDayIndex

        let result = await navigator.switchWeek(
            from: edgeIndex,
            fallbackIndex: fallbackIndex,
            loadPreviousWeek: {
                await viewModel.loadPreviousWeek()
            },
            loadNextWeek: {
                await viewModel.loadNextWeek()
            }
        )

        commit(result.targetIndex, in: viewModel.weekDates)
    }

    private func commit(_ index: Int, in weekDates: [Date]) {
        guard weekDates.indices.contains(index) else { return }

        tabIndex = index
        selectedDayIndex = index
        selectedDate = WeekDateHelper.day(for: weekDates[index])
    }

    private func reset() {
        tabIndex = Constants.firstRealWeekdayIndex
        selectedDayIndex = Constants.firstRealWeekdayIndex
        selectedDate = WeekDateHelper.day(for: Date())
    }
}
