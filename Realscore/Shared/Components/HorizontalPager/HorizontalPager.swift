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
                        let size = proxy.size
                        let capsuleWidth = capsuleWidth(
                            totalWidth: size.width,
                            itemCount: itemCount
                        )
                        let travelDistance = max(size.width - capsuleWidth, 0)

                        Capsule()
                            .frame(width: capsuleWidth)
                            .offset(
                                x: pageProgress * travelDistance
                            )
                    }
                }
        }
    }

    private func capsuleWidth(
        totalWidth: CGFloat,
        itemCount: Int
    ) -> CGFloat {
        guard itemCount > 0 else { return 0 }

        return totalWidth / CGFloat(itemCount)
    }
}
