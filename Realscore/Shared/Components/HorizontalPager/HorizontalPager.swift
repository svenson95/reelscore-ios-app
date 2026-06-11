//
//  HorizontalPager.swift
//  Realscore
//

import SwiftUI

struct HorizontalPager<PageID: Hashable, Content: View>: View {
    let pageIDs: [PageID]
    let isDisabled: Bool
    let onScrollProgress: (CGFloat) -> Void
    @Binding var selectedPage: PageID
    @ViewBuilder let content: (PageID) -> Content

    init(
        pageIDs: [PageID],
        selectedPage: Binding<PageID>,
        isDisabled: Bool = false,
        onScrollProgress: @escaping (CGFloat) -> Void = { _ in },
        @ViewBuilder content: @escaping (PageID) -> Content
    ) {
        self.pageIDs = pageIDs
        self._selectedPage = selectedPage
        self.isDisabled = isDisabled
        self.onScrollProgress = onScrollProgress
        self.content = content
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

    private func updateProgress(offset: CGFloat, pageWidth: CGFloat) {
        guard pageIDs.count > 1 else {
            onScrollProgress(0)
            return
        }

        guard pageWidth > 0 else { return }

        let currentOffset = -offset
        guard currentOffset >= 0 else { return }

        let pageProgress = currentOffset / pageWidth
        let maxPageProgress = CGFloat(pageIDs.count - 1)
        let clampedPageProgress = min(max(pageProgress, 0), maxPageProgress)

        onScrollProgress(clampedPageProgress)
    }
}
