//
//  OverviewWeekPager.swift
//  Realscore
//

import SwiftUI

struct OverviewWeekPager<PageContent: View>: View {
    let selectedIndex: Int
    let onSelectIndex: (Int) -> Void

    let weekDates: [Date]
    let isSwitchingWeek: Bool
    let isDisabled: Bool
    @ViewBuilder let pageContent: (Int) -> PageContent

    @State private var weekdayTabProgress: CGFloat = 0
    @State private var pagerPage = Constants.firstRealWeekdayIndex
    @State private var isWrappingWeek = false
    @State private var ignoresScrollProgress = false
    @State private var wrappingEdgeIndex: Int?

    private var visibleWeekDates: [Date] {
        guard weekDates.count > 2 else {
            return []
        }

        return Array(weekDates.dropFirst().dropLast())
    }

    private var allPageIDs: [Int] {
        Array(weekDates.indices)
    }

    private var pagerPageBinding: Binding<Int> {
        Binding(
            get: {
                pagerPage
            },
            set: { newIndex in
                handlePagerPageChange(newIndex)
            }
        )
    }

    private var selectedVisibleDayIndex: Int {
        let visibleIndex = selectedIndex - Constants.firstRealWeekdayIndex

        return min(
            max(visibleIndex, 0),
            max(visibleWeekDates.count - 1, 0)
        )
    }

    private var progressMapper: OverviewWeekPagerProgressMapper {
        OverviewWeekPagerProgressMapper(
            visiblePageCount: visibleWeekDates.count,
            firstVisiblePageIndex: Constants.firstRealWeekdayIndex
        )
    }

    var body: some View {
        HorizontalPager(
            pageIDs: allPageIDs,
            selectedPage: pagerPageBinding,
            isDisabled: isDisabled || weekDates.isEmpty,
            onScrollProgress: { pageProgress in
                guard !ignoresScrollProgress else { return }
                guard !isWrappingWeek else { return }
                guard !isSwitchingWeek else { return }

                weekdayTabProgress = progressMapper.tabProgress(
                    forPageProgress: pageProgress
                )
            }
        ) { index in
            pageContent(index)
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            weekdayPickerBar
        }
        .onAppear {
            DispatchQueue.main.async {
                syncPagerWithSelection(animated: false)
            }
        }
        .onChange(of: weekDates) { _, _ in
            guard !isWrappingWeek else { return }

            DispatchQueue.main.async {
                syncPagerWithSelection(animated: false)
            }
        }
        .onChange(of: selectedIndex) { _, _ in
            guard !isWrappingWeek else { return }

            syncPagerWithSelection(animated: true)
        }
        .onChange(of: isSwitchingWeek) { _, newValue in
            guard !newValue else { return }

            finishWeekWrap()
        }
    }

    @ViewBuilder
    private var weekdayPickerBar: some View {
        if !visibleWeekDates.isEmpty {
            OverviewWeekdayPickerView(
                weekDates: visibleWeekDates,
                selectedIndex: selectedVisibleDayIndex,
                tabProgress: weekdayTabProgress,
                onSelectIndex: selectVisibleDayIndex
            )
            .background(.clear)
        }
    }

    private func selectVisibleDayIndex(_ visibleIndex: Int) {
        let realIndex = visibleIndex + Constants.firstRealWeekdayIndex

        guard allPageIDs.contains(realIndex) else { return }
        guard !OverviewSelectionRules.isEdgeIndex(realIndex) else { return }
        guard selectedIndex != realIndex else { return }

        withAnimation(.snappy) {
            pagerPage = realIndex
        }

        onSelectIndex(realIndex)
    }

    private func handlePagerPageChange(_ newIndex: Int) {
        guard allPageIDs.contains(newIndex) else { return }
        guard pagerPage != newIndex else { return }
        guard !isSwitchingWeek else { return }

        pagerPage = newIndex

        if OverviewSelectionRules.isEdgeIndex(newIndex) {
            isWrappingWeek = true
            wrappingEdgeIndex = newIndex
            ignoresScrollProgress = true

            withAnimation(.snappy) {
                weekdayTabProgress = outsideTabProgress(for: newIndex)
            }

            DispatchQueue.main.async {
                onSelectIndex(newIndex)
            }

            return
        }

        onSelectIndex(newIndex)
    }

    private func syncPagerWithSelection(animated: Bool) {
        guard allPageIDs.contains(selectedIndex) else { return }

        if animated {
            guard pagerPage != selectedIndex else { return }
            
            withAnimation(.snappy) {
                pagerPage = selectedIndex
            }

            return
        }

        ignoresScrollProgress = true

        var transaction = Transaction()
        transaction.disablesAnimations = true

        withTransaction(transaction) {
            pagerPage = selectedIndex
            weekdayTabProgress = tabProgress(forRealIndex: selectedIndex)
        }

        DispatchQueue.main.async {
            ignoresScrollProgress = false
        }
    }

    private func finishWeekWrap() {
        guard allPageIDs.contains(selectedIndex) else {
            isWrappingWeek = false
            wrappingEdgeIndex = nil
            ignoresScrollProgress = false
            return
        }

        let edgeIndex = wrappingEdgeIndex

        ignoresScrollProgress = true

        var transaction = Transaction()
        transaction.disablesAnimations = true

        withTransaction(transaction) {
            pagerPage = selectedIndex

            if let edgeIndex {
                weekdayTabProgress = oppositeOutsideTabProgress(for: edgeIndex)
            } else {
                weekdayTabProgress = tabProgress(forRealIndex: selectedIndex)
            }
        }

        DispatchQueue.main.async {
            withAnimation(.snappy) {
                weekdayTabProgress = tabProgress(forRealIndex: selectedIndex)
            }

            DispatchQueue.main.async {
                ignoresScrollProgress = false
                isWrappingWeek = false
                wrappingEdgeIndex = nil
            }
        }
    }
    
    private func targetIndexAfterWeekWrap(from edgeIndex: Int) -> Int {
        switch edgeIndex {
        case Constants.previousWeekEdgeIndex:
            return Constants.lastRealWeekdayIndex

        case Constants.nextWeekEdgeIndex:
            return Constants.firstRealWeekdayIndex

        default:
            return Constants.firstRealWeekdayIndex
        }
    }

    private func prepareWeekWrapProgress(for edgeIndex: Int) {
        guard visibleWeekDates.count > 1 else { return }

        if edgeIndex == Constants.previousWeekEdgeIndex {
            weekdayTabProgress = progressMapper.rightOutsideProgress
        } else if edgeIndex == Constants.nextWeekEdgeIndex {
            weekdayTabProgress = progressMapper.leftOutsideProgress
        }
    }

    private func tabProgress(forRealIndex index: Int) -> CGFloat {
        progressMapper.tabProgress(forRealIndex: index)
    }
    
    private func outsideTabProgress(for edgeIndex: Int) -> CGFloat {
        switch edgeIndex {
        case Constants.previousWeekEdgeIndex:
            return progressMapper.leftOutsideProgress

        case Constants.nextWeekEdgeIndex:
            return progressMapper.rightOutsideProgress

        default:
            return tabProgress(forRealIndex: Constants.firstRealWeekdayIndex)
        }
    }

    private func oppositeOutsideTabProgress(for edgeIndex: Int) -> CGFloat {
        switch edgeIndex {
        case Constants.previousWeekEdgeIndex:
            return progressMapper.rightOutsideProgress

        case Constants.nextWeekEdgeIndex:
            return progressMapper.leftOutsideProgress

        default:
            return progressMapper.leftOutsideProgress
        }
    }
}
