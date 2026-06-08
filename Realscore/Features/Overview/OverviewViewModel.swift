//
//  OverviewViewModel.swift
//  Realscore
//

import Foundation
import Combine

@MainActor
final class OverviewViewModel: ObservableObject {
    @Published private(set) var weekFixtures: [[Fixture]] = []
    @Published private(set) var weekDates: [Date] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var didLoadInitialData = false

    private var currentWeekStart: Date
    private var didLoad = false
    private var isChangingWeek = false

    init() {
        currentWeekStart = Self.startOfWeek(for: Date())
        weekDates = Self.makeWeekDates(
            from: currentWeekStart,
            withEdgeDays: true
        )
    }

    var todayWeekdayIndex: Int {
        let calendar = Calendar.current

        return weekDates.firstIndex {
            calendar.isDateInToday($0)
        } ?? -1
    }

    func loadOverviewIfNeeded() async {
        guard !didLoad else { return }

        didLoad = true
        await loadOverview()
    }

    func loadOverview() async {
        await loadWeek(startingAt: currentWeekStart)
    }

    private func changeWeek(by days: Int) async -> Bool {
        guard !isChangingWeek else {
            return false
        }

        guard let newWeekStart = Calendar.current.date(
            byAdding: .day,
            value: days,
            to: currentWeekStart
        ) else {
            return false
        }

        isChangingWeek = true
        defer { isChangingWeek = false }

        return await loadWeek(startingAt: newWeekStart)
    }

    @discardableResult
    private func loadWeek(startingAt weekStart: Date) async -> Bool {
        isLoading = true
        errorMessage = nil

        let requestedWeekStart = weekStart
        let requestedWeekDates = Self.makeWeekDates(
            from: requestedWeekStart,
            withEdgeDays: true
        )

        defer {
            isLoading = false
            didLoadInitialData = true
        }

        do {
            let fixtures = try await FixturesService().getWeekFixtures(
                date: requestedWeekStart.apiDateString,
                withEdgeDays: true
            )

            guard fixtures.count == requestedWeekDates.count else {
                errorMessage = "Unerwartete Anzahl an Spieltagen"
                return false
            }

            currentWeekStart = requestedWeekStart
            weekDates = requestedWeekDates
            weekFixtures = fixtures
            return true
        } catch {
            errorMessage = "Spiele konnten nicht geladen werden"
            return false
        }
    }

    func loadPreviousWeek() async -> Bool {
        await changeWeek(by: -7)
    }
    
    func loadNextWeek() async -> Bool {
        await changeWeek(by: 7)
    }

    func fixturesForDay(at index: Int) -> [Fixture] {
        guard weekFixtures.indices.contains(index) else {
            return []
        }

        return weekFixtures[index]
    }

    private static func makeWeekDates(from weekStart: Date, withEdgeDays: Bool) -> [Date] {
        let calendar = Calendar.current

        let mondayToSunday = (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: weekStart)
        }

        guard withEdgeDays else {
            return mondayToSunday
        }

        guard
            let previousSunday = calendar.date(byAdding: .day, value: -1, to: weekStart),
            let nextMonday = calendar.date(byAdding: .day, value: 7, to: weekStart)
        else {
            return mondayToSunday
        }

        return [previousSunday] + mondayToSunday + [nextMonday]
    }

    private static func startOfWeek(for date: Date) -> Date {
        let daysFromMonday = date.weekdayIndex

        let calendar = Calendar.current
        let monday = calendar.date(
            byAdding: .day,
            value: -daysFromMonday,
            to: date
        ) ?? date

        return calendar.startOfDay(for: monday)
    }
}
