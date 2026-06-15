//
//  HorizontalPager.swift
//  Realscore
//

import SwiftUI

enum PagerLayout {
    static let CAPSULE_INSET: CGFloat = 8
}

struct HorizontalPager<PageID: Hashable, BarItem: View, Content: View>: View {
    let pageIDs: [PageID]
    let isDisabled: Bool
    let barTopSpacing: CGFloat
    let barBottomSpacing: CGFloat
    let onScrollProgress: (CGFloat) -> Void

    @Binding var selectedPage: PageID

    @ViewBuilder let content: (PageID) -> Content
    private let barItem: ((PageID) -> BarItem)?

    @State private var pageProgress: CGFloat = 0
    @State private var pendingProgrammaticIndex: Int?

    init(
        pageIDs: [PageID],
        selectedPage: Binding<PageID>,
        isDisabled: Bool = false,
        onScrollProgress: @escaping (CGFloat) -> Void = { _ in },
        @ViewBuilder content: @escaping (PageID) -> Content
    ) where BarItem == EmptyView {
        self.pageIDs = pageIDs
        self._selectedPage = selectedPage
        self.isDisabled = isDisabled
        self.barTopSpacing = 0
        self.barBottomSpacing = 0
        self.onScrollProgress = onScrollProgress
        self.content = content
        self.barItem = nil
    }

    init(
        pageIDs: [PageID],
        selectedPage: Binding<PageID>,
        isDisabled: Bool = false,
        barTopSpacing: CGFloat = 0,
        barBottomSpacing: CGFloat = 0,
        onScrollProgress: @escaping (CGFloat) -> Void = { _ in },
        @ViewBuilder barItem: @escaping (PageID) -> BarItem,
        @ViewBuilder content: @escaping (PageID) -> Content
    ) {
        self.pageIDs = pageIDs
        self._selectedPage = selectedPage
        self.isDisabled = isDisabled
        self.barTopSpacing = barTopSpacing
        self.barBottomSpacing = barBottomSpacing
        self.onScrollProgress = onScrollProgress
        self.content = content
        self.barItem = barItem
    }

    private var selectedIndex: Int {
        pageIDs.firstIndex(of: selectedPage) ?? 0
    }

    private var normalizedProgress: CGFloat {
        let maxProgress = CGFloat(pageIDs.count - 1)

        guard maxProgress > 0 else {
            return 0
        }

        return pageProgress / maxProgress
    }

    private var scrollPosition: Binding<PageID?> {
        Binding<PageID?>(
            get: {
                guard pageIDs.contains(selectedPage) else {
                    return pageIDs.first
                }

                return selectedPage
            },
            set: { newValue in
                guard let newValue else { return }
                guard pageIDs.contains(newValue) else { return }
                guard selectedPage != newValue else { return }

                selectedPage = newValue
            }
        )
    }

    var body: some View {
        pager
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

    private var pager: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(pageIDs, id: \.self) { pageID in
                        content(pageID)
                            .frame(width: proxy.size.width)
                            .containerRelativeFrame(.horizontal)
                    }
                }
                .scrollTargetLayout()
                .offsetX { offset in
                    updateProgress(
                        offset: offset,
                        pageWidth: proxy.size.width
                    )
                }
            }
            .scrollPosition(id: scrollPosition)
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            .scrollDisabled(isDisabled)
        }
    }

    @ViewBuilder
    private var pagerBar: some View {
        if let barItem, !pageIDs.isEmpty {
            HorizontalPagerBar(
                itemCount: pageIDs.count,
                selectedIndex: selectedIndex,
                tabProgress: normalizedProgress,
                onSelectIndex: selectIndex
            ) { index in
                barItem(pageIDs[index])
            }
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

    private func updateProgress(offset: CGFloat, pageWidth: CGFloat) {
        guard pageIDs.count > 1 else {
            pageProgress = 0
            onScrollProgress(0)
            return
        }

        guard pageWidth > 0 else { return }

        let currentOffset = -offset
        guard currentOffset >= 0 else { return }

        let rawProgress = currentOffset / pageWidth
        let maxProgress = CGFloat(pageIDs.count - 1)
        let progress = min(max(rawProgress, 0), maxProgress)

        handleInternalProgress(progress)
        onScrollProgress(progress)
    }

    private func handleInternalProgress(_ progress: CGFloat) {
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

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func offsetX(completion: @escaping (CGFloat) -> Void) -> some View {
        self
            .overlay {
                GeometryReader { proxy in
                    let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX

                    Color.clear
                        .preference(key: OffsetKey.self, value: minX)
                        .onPreferenceChange(OffsetKey.self, perform: completion)
                }
            }
    }
}

extension View {
    @ViewBuilder
    func pagerMask(
        pageProgress: CGFloat,
        itemCount: Int
    ) -> some View {
        ZStack {
            self
                .foregroundStyle(.secondary)

            self
                .foregroundStyle(.accent)
                .mask {
                    GeometryReader { proxy in
                        let width = proxy.size.width
                        let height = proxy.size.height
                        let metrics = PagerCapsuleMetrics(
                            totalWidth: width,
                            totalHeight: height,
                            itemCount: itemCount,
                            progress: pageProgress
                        )

                        if metrics.isValid {
                            Capsule()
                                .frame(
                                    width: metrics.capsuleWidth,
                                    height: metrics.capsuleHeight
                                )
                                .position(
                                    x: metrics.centerX,
                                    y: metrics.centerY
                                )
                        }
                    }
                }
        }
    }
}
