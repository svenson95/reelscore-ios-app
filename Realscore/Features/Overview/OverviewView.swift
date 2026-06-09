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

    private var selectedDayBinding: Binding<Int> {
        selectionStore.dayBinding(viewModel: viewModel)
    }

    private var tabViewID: String {
        "\(viewModel.visibleWeekStart.apiDateString)-\(viewModel.refreshID)"
    }

    var body: some View {
        content
            .background(Color(.systemGroupedBackground))
            .scrollContentBackground(.hidden)
            .overlay {
                loadingOverlay
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
            .refreshable {
                guard !selectionStore.isSwitchingWeek else { return }
                await viewModel.refreshVisibleWeek()
            }
            .onDisappear {
                selectionStore.cancelPendingTask()
            }
    }

    private var content: some View {
        VStack(spacing: 0) {
            weekdayPicker

            TabView(selection: selectedDayBinding) {
                ForEach(viewModel.weekDates.indices, id: \.self) { index in
                    tabView(for: index)
                        .tag(index)
                }
            }
            .id(tabViewID)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .disabled(selectionStore.isSwitchingWeek)
            .onChange(of: viewModel.weekDates) { _, weekDates in
                selectionStore.handleWeekDatesChange(weekDates)
            }
        }
        .disabled(isDatePickerPresented)
    }

    @ViewBuilder
    private var loadingOverlay: some View {
        if viewModel.isLoading && !viewModel.didLoadInitialData {
            LoadingView()
        }
    }

    @ViewBuilder
    private var weekdayPicker: some View {
        if !viewModel.weekDates.isEmpty {
            OverviewWeekdayPickerView(
                weekDates: viewModel.weekDates,
                selectedDayIndex: selectedDayBinding
            )
        }
    }

    private func tabView(for index: Int) -> some View {
        OverviewTabView(
            fixtures: viewModel.fixturesForDay(at: index),
            errorMessage: viewModel.errorMessage,
            isLoading: viewModel.isLoading,
            didLoadInitialData: viewModel.didLoadInitialData,
            canReload: !selectionStore.isSwitchingWeek,
            onReload: {
                await viewModel.refreshVisibleWeek()
            }
        )
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
