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
    @Published private(set) var refreshID = UUID()

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
        WeekDateHelper.realWeekdayIndex(for: Date())
    }

    func loadOverviewIfNeeded() async {
        guard !didLoad else { return }

        let didSucceed = await loadData(date: Date())
        if didSucceed {
            didLoad = true
        }
    }

    @discardableResult
    func refreshVisibleWeek() async -> Bool {
        await loadData(date: visibleWeekStart)
    }

    @discardableResult
    func loadCurrentWeek() async -> Bool {
        await loadData(date: Date())
    }

    @discardableResult
    func loadWeek(containing date: Date) async -> Bool {
        await loadData(date: date)
    }

    func fixturesForDay(at index: Int) -> [Fixture] {
        guard weekdayItems.indices.contains(index) else {
            return []
        }

        return weekdayItems[index].fixtures
    }
    
    func prepareWeek(containing date: Date) {
        let selectedDate = WeekDateHelper.day(for: date)
        let newStart = WeekDateHelper.start(for: selectedDate)

        guard !Calendar.appCalendar.isDate(newStart, inSameDayAs: visibleWeekStart) else {
            return
        }

        weekStart = newStart
        visibleWeekStart = newStart
        weekdayItems = WeekdayItemFactory.empty(from: newStart)

        errorMessage = nil
        refreshID = UUID()
    }

    @discardableResult
    private func loadData(date: Date) async -> Bool {
        guard !isBusy else {
            return false
        }

        isBusy = true
        defer { isBusy = false }

        return await loadWeek(date: date)
    }

    @discardableResult
    private func loadWeek(date: Date) async -> Bool {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
            didLoadInitialData = true
        }

        let selectedDate = WeekDateHelper.day(for: date)
        let newStart = WeekDateHelper.start(for: selectedDate)
        let newDates = WeekDateHelper.dates(from: newStart)

        do {
            let fixtures = try await service.getWeekFixtures(
                date: selectedDate.apiDateString,
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
            print("❌ Fixtures loading failed:", error)
            return false
        }
    }

    private func commitWeek(start: Date, items: [WeekdayItem]) {
        weekStart = start
        visibleWeekStart = start
        weekdayItems = items
        refreshID = UUID()
    }
}
