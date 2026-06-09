//
//  OverviewViewModel.swift
//  Realscore
//

import Foundation
import Combine

@MainActor
final class OverviewViewModel: ObservableObject {
    @Published private(set) var weekdayItems: [WeekdayItem] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var didLoadInitialData = false
    @Published private(set) var visibleWeekStart: Date

    private let service: FixturesServiceProvider

    private var weekStart: Date
    private var didLoad = false
    private var isBusy = false

    init(service: FixturesServiceProvider? = nil) {
        self.service = service ?? FixturesService.shared

        let start = WeekDateHelper.start(for: Date())
        weekStart = start
        visibleWeekStart = start
        weekdayItems = WeekdayItemFactory.empty(from: start)
    }

    var weekDates: [Date] {
        weekdayItems.map(\.date)
    }

    var todayWeekdayIndex: Int {
        weekdayItems.firstIndex {
            Calendar.current.isDateInToday($0.date)
        } ?? -1
    }

    func loadOverviewIfNeeded() async {
        guard !didLoad else { return }

        didLoad = true
        await loadOverview()
    }

    func loadOverview() async {
        await loadWeek(weekStart)
    }

    @discardableResult
    func loadCurrentWeek() async -> Bool {
        let start = WeekDateHelper.start(for: Date())
        return await loadLocked(start)
    }

    func loadPreviousWeek() async -> Bool {
        await shiftWeek(by: -7)
    }

    func loadNextWeek() async -> Bool {
        await shiftWeek(by: 7)
    }

    func fixturesForDay(at index: Int) -> [Fixture] {
        guard weekdayItems.indices.contains(index) else {
            return []
        }

        return weekdayItems[index].fixtures
    }

//    func dateForDay(at index: Int) -> Date? {
//        guard weekdayItems.indices.contains(index) else {
//            return nil
//        }
//
//        return weekdayItems[index].date
//    }

    private func shiftWeek(by days: Int) async -> Bool {
        guard let start = WeekDateHelper.addDays(days, to: weekStart) else {
            return false
        }

        return await loadLocked(start)
    }

    private func loadLocked(_ start: Date) async -> Bool {
        guard !isBusy else {
            return false
        }

        isBusy = true
        defer { isBusy = false }

        return await loadWeek(start)
    }

    @discardableResult
    private func loadWeek(_ start: Date) async -> Bool {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
            didLoadInitialData = true
        }

        let newStart = WeekDateHelper.start(for: start)
        let newDates = WeekDateHelper.dates(from: newStart)

        do {
            let fixtures = try await service.getWeekFixtures(
                date: newStart.apiDateString,
                withEdgeDays: true
            )

            guard let newItems = WeekdayItemFactory.make(
                dates: newDates,
                fixtures: fixtures
            ) else {
                errorMessage = "Unerwartete Anzahl an Spieltagen"
                return false
            }

            commitWeek(start: newStart, items: newItems)
            return true
        } catch is CancellationError {
            return false
        } catch {
            errorMessage = "Spiele konnten nicht geladen werden"
            return false
        }
    }

    private func commitWeek(start: Date, items: [WeekdayItem]) {
        weekStart = start
        weekdayItems = items
        visibleWeekStart = start
    }
}
