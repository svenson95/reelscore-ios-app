//
//  OverviewView.swift
//  Realscore
//

import SwiftUI

struct OverviewView: View {
    @StateObject private var viewModel = OverviewViewModel()
    @StateObject private var selectionStore = OverviewSelectionStore()

    private var selectedDayBinding: Binding<Int> {
        selectionStore.dayBinding(viewModel: viewModel)
    }

    private var tabViewID: String {
        viewModel.visibleWeekStart.apiDateString
    }

    var body: some View {
        content
            .background(Color(.systemGroupedBackground))
            .scrollContentBackground(.hidden)
            .overlay {
                if viewModel.isLoading && !viewModel.didLoadInitialData {
                    LoadingView()
                }
            }
            .navigationTitle("Überblick")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                OverviewToolbar(
                    dateText: selectionStore.selectedDateText,
                    showsTodayButton: !selectionStore.isTodaySelected,
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
                await viewModel.loadOverview()
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
                await viewModel.loadOverview()
            }
        )
    }
}
