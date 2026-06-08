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

    private let fixturesService = FixturesService()

    private var currentWeekStart: Date
    private var didLoad = false
    private var isLoadingWeek = false

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

    @discardableResult
    func loadCurrentWeek() async -> Bool {
        guard !isLoadingWeek else {
            return false
        }

        isLoadingWeek = true
        defer { isLoadingWeek = false }

        let currentWeekStart = Self.startOfWeek(for: Date())

        return await loadWeek(startingAt: currentWeekStart)
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

    func dateForDay(at index: Int) -> Date? {
        guard weekDates.indices.contains(index) else {
            return nil
        }

        return weekDates[index]
    }

    private func changeWeek(by days: Int) async -> Bool {
        guard !isLoadingWeek else {
            return false
        }

        guard let newWeekStart = Calendar.current.date(
            byAdding: .day,
            value: days,
            to: currentWeekStart
        ) else {
            return false
        }

        isLoadingWeek = true
        defer { isLoadingWeek = false }

        return await loadWeek(startingAt: newWeekStart)
    }

    @discardableResult
    private func loadWeek(startingAt weekStart: Date) async -> Bool {
        isLoading = true
        defer {
            isLoading = false
            didLoadInitialData = true
        }

        errorMessage = nil

        let requestedWeekStart = Self.startOfWeek(for: weekStart)

        let requestedWeekDates = Self.makeWeekDates(
            from: requestedWeekStart,
            withEdgeDays: true
        )

        do {
            let fixtures = try await fixturesService.getWeekFixtures(
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
        } catch is CancellationError {
            return false
        } catch {
            errorMessage = "Spiele konnten nicht geladen werden"
            return false
        }
    }

    private static func makeWeekDates(from weekStart: Date, withEdgeDays: Bool) -> [Date] {
        let calendar = Calendar.current
        let normalizedWeekStart = calendar.startOfDay(for: weekStart)

        let mondayToSunday = (0..<7).compactMap { offset in
            calendar.date(
                byAdding: .day,
                value: offset,
                to: normalizedWeekStart
            )
        }

        guard withEdgeDays else {
            return mondayToSunday
        }

        guard
            let previousSunday = calendar.date(
                byAdding: .day,
                value: -1,
                to: normalizedWeekStart
            ),
            let nextMonday = calendar.date(
                byAdding: .day,
                value: 7,
                to: normalizedWeekStart
            )
        else {
            return mondayToSunday
        }

        return [previousSunday] + mondayToSunday + [nextMonday]
    }

    private static func startOfWeek(for date: Date) -> Date {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let daysFromMonday = startOfDay.weekdayIndex

        let monday = calendar.date(
            byAdding: .day,
            value: -daysFromMonday,
            to: startOfDay
        ) ?? startOfDay

        return calendar.startOfDay(for: monday)
    }
}
