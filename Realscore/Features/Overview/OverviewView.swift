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

    private var selectedFixtures: [Fixture] {
        viewModel.fixturesForDay(at: selectedDayBinding.wrappedValue)
    }

    private var shouldShowInitialLoadingState: Bool {
        viewModel.isLoading
            && !viewModel.didLoadInitialData
            && selectedFixtures.isEmpty
    }

    var body: some View {
        Group {
            if shouldShowInitialLoadingState {
                ProgressView()
            } else {
                overviewPager
            }
        }
        .disabled(isDatePickerPresented)
        .fullScreenCover(isPresented: $isDatePickerPresented) {
            OverviewDatePickerOverlay(
                selectedDate: $datePickerSelection,
                onSelectDate: { date in
                    selectDate(date)
                },
                onDismiss: {
                    isDatePickerPresented = false
                }
            )
            .presentationBackground(.clear)
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
        .navigationDestination(item: $selectedFixture) { fixture in
            MatchView(fixture: fixture)
        }
    }

    private var overviewPager: some View {
        OverviewDayPager(
            selectedIndex: selectedDayBinding.wrappedValue,
            onSelectIndex: { index in
                selectedDayBinding.wrappedValue = index
            },
            weekDates: viewModel.weekDates,
            isSwitchingWeek: selectionStore.isSwitchingWeek,
            isDisabled: selectionStore.isSwitchingWeek
        ) { index in
            overviewList(for: index)
        }
    }

    private func overviewList(for index: Int) -> some View {
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

    private func refreshOverview() async {
        guard !selectionStore.isSwitchingWeek else { return }

        await viewModel.refreshVisibleWeek()
    }

    private func showDatePicker() {
        datePickerSelection = selectionStore.selectedDate
        isDatePickerPresented = true
    }

    private func selectDate(_ date: Date) {
        isDatePickerPresented = false

        Task {
            await selectionStore.selectDate(
                date,
                viewModel: viewModel
            )
        }
    }
}

#Preview {
    OverviewView()
}
