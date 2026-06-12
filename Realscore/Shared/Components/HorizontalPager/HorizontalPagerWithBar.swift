//
//  HorizontalPagerWithBar.swift
//  Realscore
//

import SwiftUI

struct HorizontalPagerWithBar<PageID: Hashable, BarItem: View, PageContent: View>: View {
    let pageIDs: [PageID]
    let isDisabled: Bool
    let barTopSpacing: CGFloat
    let barBottomSpacing: CGFloat

    @Binding var selectedPage: PageID

    @ViewBuilder let barItem: (PageID) -> BarItem
    @ViewBuilder let pageContent: (PageID) -> PageContent

    @State private var pageProgress: CGFloat = 0
    @State private var pendingProgrammaticIndex: Int?

    init(
        pageIDs: [PageID],
        selectedPage: Binding<PageID>,
        isDisabled: Bool = false,
        barTopSpacing: CGFloat = 0,
        barBottomSpacing: CGFloat = 0,
        @ViewBuilder barItem: @escaping (PageID) -> BarItem,
        @ViewBuilder pageContent: @escaping (PageID) -> PageContent
    ) {
        self.pageIDs = pageIDs
        self._selectedPage = selectedPage
        self.isDisabled = isDisabled
        self.barTopSpacing = barTopSpacing
        self.barBottomSpacing = barBottomSpacing
        self.barItem = barItem
        self.pageContent = pageContent
    }

    private var selectedIndex: Int {
        pageIDs.firstIndex(of: selectedPage) ?? 0
    }

    private var normalizedProgress: CGFloat {
        let maxProgress = CGFloat(pageIDs.count - 1)

        guard maxProgress > 0 else {
            return 0
        }

        return min(max(pageProgress / maxProgress, 0), 1)
    }

    var body: some View {
        HorizontalPager(
            pageIDs: pageIDs,
            selectedPage: $selectedPage,
            isDisabled: isDisabled,
            onScrollProgress: handleScrollProgress
        ) { pageID in
            pageContent(pageID)
        }
        .safeAreaInset(edge: .top, spacing: barBottomSpacing) {
            pagerBar
                .padding(.top, barTopSpacing)
        }
        .onAppear {
            syncProgressWithSelection(animated: false)
        }
        .onChange(of: selectedPage) { _, _ in
            syncProgressWithSelection(animated: true)
        }
        .onChange(of: pageIDs) { _, _ in
            syncProgressWithSelection(animated: false)
        }
    }

    private var pagerBar: some View {
        HorizontalPagerBar(
            itemCount: pageIDs.count,
            selectedIndex: selectedIndex,
            tabProgress: normalizedProgress,
            onSelectIndex: selectIndex
        ) { index in
            barItem(pageIDs[index])
        }
    }

    private func selectIndex(_ index: Int) {
        guard pageIDs.indices.contains(index) else { return }

        let pageID = pageIDs[index]

        guard selectedPage != pageID else { return }

        pendingProgrammaticIndex = index

        withAnimation(.snappy) {
            selectedPage = pageID
            pageProgress = CGFloat(index)
        }
    }

    private func handleScrollProgress(_ progress: CGFloat) {
        if let pendingProgrammaticIndex {
            let targetProgress = CGFloat(pendingProgrammaticIndex)
            let distanceToTarget = abs(progress - targetProgress)

            guard distanceToTarget < 0.05 else {
                return
            }

            self.pendingProgrammaticIndex = nil
            pageProgress = targetProgress
            return
        }

        pageProgress = progress
    }

    private func syncProgressWithSelection(animated: Bool) {
        guard let index = pageIDs.firstIndex(of: selectedPage) else {
            pageProgress = 0
            pendingProgrammaticIndex = nil
            return
        }

        let targetProgress = CGFloat(index)

        guard pageProgress != targetProgress else {
            return
        }

        pendingProgrammaticIndex = index

        if animated {
            withAnimation(.snappy) {
                pageProgress = targetProgress
            }
        } else {
            var transaction = Transaction()
            transaction.disablesAnimations = true

            withTransaction(transaction) {
                pageProgress = targetProgress
            }
        }
    }
}
