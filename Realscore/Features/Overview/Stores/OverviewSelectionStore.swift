//
//  OverviewSelectionStore.swift
//  Realscore
//

import SwiftUI
import Combine

@MainActor
final class OverviewSelectionStore: ObservableObject {
    @Published private(set) var selectedDate = Date()
    @Published private(set) var selectedDayIndex = Constants.firstRealWeekdayIndex
    @Published private(set) var isSwitchingWeek = false

    @Published var tabIndex = Constants.firstRealWeekdayIndex

    private var didSelectInitialDay = false
    private var pendingTask: Task<Void, Never>?

    var selectedDateText: String {
        selectedDate.dayMonthYearString
    }

    var isTodaySelected: Bool {
        Calendar.appCalendar.isDate(selectedDate, inSameDayAs: Date())
    }

    func dayBinding(viewModel: OverviewViewModel) -> Binding<Int> {
        Binding(
            get: {
                self.tabIndex
            },
            set: { newIndex in
                self.handleTabChange(newIndex, viewModel: viewModel)
            }
        )
    }

    func cancelPendingTask() {
        pendingTask?.cancel()
        pendingTask = nil
    }

    func selectInitialDayIfNeeded(viewModel: OverviewViewModel) {
        guard !didSelectInitialDay else { return }
        guard !viewModel.weekDates.isEmpty else { return }

        let todayIndex = viewModel.todayWeekdayIndex

        let index = viewModel.weekDates.indices.contains(todayIndex)
            ? todayIndex
            : Constants.firstRealWeekdayIndex

        commit(index, in: viewModel.weekDates)
        didSelectInitialDay = true
    }

    func selectToday(viewModel: OverviewViewModel) async {
        guard !isSwitchingWeek else { return }

        cancelPendingTask()

        let today = Date()

        if let index = viewModel.weekDates.firstIndex(where: {
            Calendar.appCalendar.isDate($0, inSameDayAs: today)
        }) {
            if !isEdgeIndex(index) {
                commit(index, in: viewModel.weekDates)
                return
            }
        }

        isSwitchingWeek = true
        defer { isSwitchingWeek = false }

        let didLoad = await viewModel.loadCurrentWeek()

        guard didLoad else { return }

        guard let index = viewModel.weekDates.firstIndex(where: {
            Calendar.appCalendar.isDate($0, inSameDayAs: today)
        }) else {
            commit(Constants.firstRealWeekdayIndex, in: viewModel.weekDates)
            return
        }

        let targetIndex = isEdgeIndex(index)
            ? Constants.firstRealWeekdayIndex
            : index

        commit(targetIndex, in: viewModel.weekDates)
    }

    func handleWeekDatesChange(_ weekDates: [Date]) {
        guard !isSwitchingWeek else { return }

        guard !weekDates.isEmpty else {
            reset()
            return
        }

        if !weekDates.indices.contains(tabIndex) {
            tabIndex = max(0, weekDates.count - 1)
        }

        if !weekDates.indices.contains(selectedDayIndex) {
            commit(tabIndex, in: weekDates)
        }
    }

    private func handleTabChange(
        _ index: Int,
        viewModel: OverviewViewModel
    ) {
        guard viewModel.weekDates.indices.contains(index) else { return }
        guard !isSwitchingWeek else { return }

        cancelPendingTask()

        commit(index, in: viewModel.weekDates)

        guard isEdgeIndex(index) else { return }

        pendingTask = Task { @MainActor in
            await switchWeek(from: index, viewModel: viewModel)
            pendingTask = nil
        }
    }

    private func switchWeek(
        from edgeIndex: Int,
        viewModel: OverviewViewModel
    ) async {
        guard !isSwitchingWeek else { return }

        isSwitchingWeek = true
        defer { isSwitchingWeek = false }

        if edgeIndex == Constants.previousWeekEdgeIndex {
            await switchToPreviousWeek(viewModel: viewModel)
            return
        }

        if edgeIndex == Constants.nextWeekEdgeIndex {
            await switchToNextWeek(viewModel: viewModel)
            return
        }
    }

    private func switchToPreviousWeek(viewModel: OverviewViewModel) async {
        let fallbackIndex = selectedDayIndex
        let targetIndex = Constants.lastRealWeekdayIndex

        let didLoad = await viewModel.loadPreviousWeek()

        guard didLoad else {
            commit(fallbackIndex, in: viewModel.weekDates)
            return
        }

        commit(targetIndex, in: viewModel.weekDates)
    }

    private func switchToNextWeek(viewModel: OverviewViewModel) async {
        let fallbackIndex = selectedDayIndex
        let targetIndex = Constants.firstRealWeekdayIndex

        let didLoad = await viewModel.loadNextWeek()

        guard didLoad else {
            commit(fallbackIndex, in: viewModel.weekDates)
            return
        }

        commit(targetIndex, in: viewModel.weekDates)
    }

    private func commit(_ index: Int, in weekDates: [Date]) {
        guard weekDates.indices.contains(index) else { return }

        tabIndex = index
        selectedDayIndex = index
        selectedDate = weekDates[index]
    }

    private func reset() {
        tabIndex = Constants.firstRealWeekdayIndex
        selectedDayIndex = Constants.firstRealWeekdayIndex
        selectedDate = Date()
    }

    private func isEdgeIndex(_ index: Int) -> Bool {
        index == Constants.previousWeekEdgeIndex ||
        index == Constants.nextWeekEdgeIndex
    }
    
    func selectDate(
        _ date: Date,
        viewModel: OverviewViewModel
    ) async {
        guard !isSwitchingWeek else { return }

        cancelPendingTask()

        if let index = viewModel.weekDates.firstIndex(where: {
            Calendar.appCalendar.isDate($0, inSameDayAs: date)
        }) {
            if !isEdgeIndex(index) {
                commit(index, in: viewModel.weekDates)
                return
            }
        }

        isSwitchingWeek = true
        defer { isSwitchingWeek = false }

        let didLoad = await viewModel.loadWeek(containing: date)

        guard didLoad else { return }

        guard let index = viewModel.weekDates.firstIndex(where: {
            Calendar.appCalendar.isDate($0, inSameDayAs: date)
        }) else {
            commit(Constants.firstRealWeekdayIndex, in: viewModel.weekDates)
            return
        }

        let targetIndex = isEdgeIndex(index)
            ? Constants.firstRealWeekdayIndex
            : index

        commit(targetIndex, in: viewModel.weekDates)
    }
}
