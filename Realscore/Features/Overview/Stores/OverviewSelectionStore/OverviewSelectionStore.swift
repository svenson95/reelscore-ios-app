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

    private let navigator = OverviewSelectionNavigator()

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
        isSwitchingWeek = false
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

        if OverviewSelectionRules.isEdgeIndex(index) {
            beginWeekSwitch(from: index, viewModel: viewModel)
            return
        }

        guard !isSwitchingWeek else { return }

        cancelPendingTask()
        commit(index, in: viewModel.weekDates)
    }

    private func beginWeekSwitch(
        from edgeIndex: Int,
        viewModel: OverviewViewModel
    ) {
        guard !isSwitchingWeek else { return }
        guard pendingTask == nil else { return }
        guard viewModel.weekDates.indices.contains(edgeIndex) else { return }
        guard OverviewSelectionRules.isEdgeIndex(edgeIndex) else { return }

        isSwitchingWeek = true

        pendingTask = Task { @MainActor in
            defer {
                isSwitchingWeek = false
                pendingTask = nil
            }

            await switchWeek(
                from: edgeIndex,
                viewModel: viewModel
            )
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

        let normalizedDate = WeekDateHelper.day(for: date)

        viewModel.prepareWeek(containing: normalizedDate)

        let index = navigator.indexForLoadedDate(
            normalizedDate,
            weekDates: viewModel.weekDates
        )

        commit(index, in: viewModel.weekDates)

        let didLoad = await loadWeek()
        guard didLoad else { return }
        guard !Task.isCancelled else { return }
    }

    private func switchWeek(
        from edgeIndex: Int,
        viewModel: OverviewViewModel
    ) async {
        let oldWeekDates = viewModel.weekDates
        let fallbackIndex = selectedDayIndex

        guard oldWeekDates.indices.contains(edgeIndex) else { return }

        let targetDate = WeekDateHelper.day(for: oldWeekDates[edgeIndex])
        let targetIndex = targetIndexAfterWeekSwitch(from: edgeIndex)
        let didLoad = await viewModel.loadWeek(containing: targetDate)

        guard !Task.isCancelled else { return }

        guard didLoad else {
            commit(fallbackIndex, in: viewModel.weekDates)
            return
        }

        commit(targetIndex, in: viewModel.weekDates)
    }

    private func targetIndexAfterWeekSwitch(from edgeIndex: Int) -> Int {
        switch edgeIndex {
        case Constants.previousWeekEdgeIndex:
            return Constants.lastRealWeekdayIndex

        case Constants.nextWeekEdgeIndex:
            return Constants.firstRealWeekdayIndex

        default:
            return Constants.firstRealWeekdayIndex
        }
    }

    private func commit(_ index: Int, in weekDates: [Date]) {
        guard weekDates.indices.contains(index) else { return }
        guard !OverviewSelectionRules.isEdgeIndex(index) else { return }

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
