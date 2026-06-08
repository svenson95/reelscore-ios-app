//
//  SelectedDateStore.swift
//  Realscore
//

import Foundation
import Combine

@MainActor
final class SelectedDateStore: ObservableObject {
    @Published var selectedDayIndex: Int
    @Published var selectedDate: Date

    init(
        selectedDayIndex: Int? = nil,
        selectedDate: Date = Date()
    ) {
        self.selectedDayIndex = selectedDayIndex ?? Constants.firstRealWeekdayIndex
        self.selectedDate = selectedDate
    }

    func selectDay(at index: Int, in weekDates: [Date]) {
        guard weekDates.indices.contains(index) else { return }

        selectedDayIndex = index
        selectedDate = weekDates[index]
    }

    func selectDate(_ date: Date, in weekDates: [Date]) {
        selectedDate = date

        if let index = weekDates.firstIndex(where: {
            Calendar.current.isDate($0, inSameDayAs: date)
        }) {
            selectedDayIndex = index
        }
    }

    func selectToday(
        in weekDates: [Date],
        fallbackIndex: Int? = nil
    ) {
        let fallbackIndex = fallbackIndex ?? Constants.firstRealWeekdayIndex
        let today = Date()

        if let todayIndex = weekDates.firstIndex(where: {
            Calendar.current.isDate($0, inSameDayAs: today)
        }) {
            selectDay(at: todayIndex, in: weekDates)
            return
        }

        selectDay(at: fallbackIndex, in: weekDates)
    }

    func clampSelectionIfNeeded(in weekDates: [Date]) {
        guard !weekDates.isEmpty else { return }

        if weekDates.indices.contains(selectedDayIndex) {
            selectedDate = weekDates[selectedDayIndex]
            return
        }

        let fallbackIndex = max(0, weekDates.count - 1)
        selectDay(at: fallbackIndex, in: weekDates)
    }

    func reset(fallbackIndex: Int? = nil) {
        selectedDayIndex = fallbackIndex ?? Constants.firstRealWeekdayIndex
        selectedDate = Date()
    }
}
