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

    init() {
        currentWeekStart = Self.startOfWeek(for: Date())
        weekDates = Self.makeWeekDates(from: currentWeekStart, withEdgeDays: true)
    }

    var todayWeekdayIndex: Int {
        let weekday = Calendar.current.component(.weekday, from: Date())

        // Swift:
        // Sunday = 1, Monday = 2, ..., Saturday = 7
        //
        // App:
        // Monday = 0, Tuesday = 1, ..., Sunday = 6
        return weekday == 1 ? 6 : weekday - 2
    }

    func loadOverviewIfNeeded() async {
        guard !didLoad else { return }

        didLoad = true
        await loadOverview()
    }

    func loadOverview() async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
            didLoadInitialData = true
        }

        do {
            let dateString = currentWeekStart.apiDateString
            weekFixtures = try await FixturesService().getWeekFixtures(
                date: dateString,
                withEdgeDays: true
            )
            weekDates = Self.makeWeekDates(from: currentWeekStart, withEdgeDays: true)
        } catch {
            errorMessage = "Spiele konnten nicht geladen werden"
        }
    }

    func loadNextWeek() async {
        guard let nextWeekStart = Calendar.current.date(
            byAdding: .day,
            value: 7,
            to: currentWeekStart
        ) else {
            return
        }

        currentWeekStart = nextWeekStart
        await loadOverview()
    }

    func loadPreviousWeek() async {
        guard let previousWeekStart = Calendar.current.date(
            byAdding: .day,
            value: -7,
            to: currentWeekStart
        ) else {
            return
        }

        currentWeekStart = previousWeekStart
        await loadOverview()
    }

    func fixturesForDay(at index: Int) -> [Fixture] {
        guard weekFixtures.indices.contains(index) else {
            return []
        }

        return weekFixtures[index]
    }

    func dayItem(for index: Int) -> WeekdayItem {
        guard weekDates.indices.contains(index) else {
            return WeekdayItem(date: Date())
        }

        return WeekdayItem(date: weekDates[index])
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
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)

        // Swift:
        // Sunday = 1, Monday = 2, ..., Saturday = 7
        //
        // Montag als Wochenstart:
        let daysFromMonday = (weekday + 5) % 7

        let monday = calendar.date(byAdding: .day, value: -daysFromMonday, to: date) ?? date

        return calendar.startOfDay(for: monday)
    }
}
