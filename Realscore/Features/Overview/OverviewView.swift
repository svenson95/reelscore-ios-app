//
//  OverviewView.swift
//  Realscore
//

import SwiftUI

struct OverviewView: View {
    @StateObject private var viewModel = OverviewViewModel()
    @StateObject private var selectionStore = OverviewSelectionStore()

    @State private var isDatePickerPresented = false
    @State private var datePickerSelection = Date()
    @State private var selectedFixture: Fixture?

    private var selectedDayBinding: Binding<Int> {
        selectionStore.dayBinding(viewModel: viewModel)
    }

    var body: some View {
        Group {
            if viewModel.isLoading && !viewModel.didLoadInitialData {
                ProgressView()
            } else {
                overviewPager
                    .safeAreaInset(edge: .top, spacing: 0) {
                        weekdayPickerBar
                    }
            }
        }
        .overlay {
            datePickerOverlay
        }
        .animation(.easeInOut(duration: 0.2), value: isDatePickerPresented)
        .navigationTitle("Überblick")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            OverviewToolbar(
                dateText: selectionStore.selectedDateText,
                showsTodayButton: !selectionStore.isTodaySelected,
                onDateTap: {
                    showDatePicker()
                },
                onToday: {
                    Task {
                        await selectionStore.selectToday(viewModel: viewModel)
                    }
                }
            )
        }
        .task {
            selectionStore.selectInitialDayIfNeeded(viewModel: viewModel)
            await viewModel.loadOverviewIfNeeded()
            selectionStore.selectInitialDayIfNeeded(viewModel: viewModel)
        }
        .onDisappear {
            selectionStore.cancelPendingTask()
        }
        .onChange(of: viewModel.weekDates) { _, weekDates in
            selectionStore.handleWeekDatesChange(weekDates)
        }
        .navigationDestination(item: $selectedFixture) { fixture in
            MatchView(fixture: fixture)
        }
        .disabled(isDatePickerPresented)
    }

    private var overviewPager: some View {
        OverviewHorizontalPager(
            pageIDs: Array(viewModel.weekDates.indices),
            selectedPage: selectedDayBinding,
            isDisabled: selectionStore.isSwitchingWeek || viewModel.weekDates.isEmpty
        ) { index in
            overviewList(for: index)
        }
    }

    private func overviewList(for index: Int) -> some View {
        List {
            OverviewContentView(
                fixtures: viewModel.fixturesForDay(at: index),
                errorMessage: viewModel.errorMessage,
                isLoading: viewModel.isLoading,
                didLoadInitialData: viewModel.didLoadInitialData,
                onRetry: {
                    await refreshOverview()
                },
                onFixtureTap: { fixture in
                    selectedFixture = fixture
                }
            )
        }
        .refreshable {
            await refreshOverview()
        }
    }

    @ViewBuilder
    private var weekdayPickerBar: some View {
        if !viewModel.weekDates.isEmpty {
            OverviewWeekdayPickerView(
                weekDates: viewModel.weekDates,
                selectedDayIndex: selectedDayBinding
            )
            .background(.clear)
        }
    }

    @ViewBuilder
    private var datePickerOverlay: some View {
        if isDatePickerPresented {
            OverviewDatePickerOverlay(
                selectedDate: $datePickerSelection,
                onSelectDate: { date in
                    selectDate(date)
                },
                onDismiss: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isDatePickerPresented = false
                    }
                }
            )
        }
    }
    
    private func refreshOverview() async {
        guard !selectionStore.isSwitchingWeek else { return }

        await viewModel.refreshVisibleWeek()
    }

    private func showDatePicker() {
        datePickerSelection = selectionStore.selectedDate
        isDatePickerPresented = true
    }

    private func selectDate(_ date: Date) {
        withAnimation(.easeInOut(duration: 0.2)) {
            isDatePickerPresented = false
        }

        Task {
            await selectionStore.selectDate(
                date,
                viewModel: viewModel
            )
        }
    }
}
