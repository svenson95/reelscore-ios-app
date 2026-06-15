//
//  HorizontalPagerBar.swift
//  Realscore
//

import SwiftUI

struct HorizontalPagerBarLayout {
    static let height: CGFloat = 50
    static let horizontalPadding: CGFloat = AppLayout.medium
}

struct HorizontalPagerBar<Item: View>: View {
    let itemCount: Int
    let selectedIndex: Int
    let tabProgress: CGFloat?
    let onSelectIndex: (Int) -> Void

    @ViewBuilder let item: (Int) -> Item

    @Environment(\.colorScheme) private var scheme

    init(
        itemCount: Int,
        selectedIndex: Int,
        tabProgress: CGFloat? = nil,
        onSelectIndex: @escaping (Int) -> Void,
        @ViewBuilder item: @escaping (Int) -> Item
    ) {
        self.itemCount = itemCount
        self.selectedIndex = selectedIndex
        self.tabProgress = tabProgress
        self.onSelectIndex = onSelectIndex
        self.item = item
    }

    private var resolvedTabProgress: CGFloat {
        if let tabProgress, tabProgress.isFinite {
            return tabProgress
        }

        guard itemCount > 1 else { return 0 }

        let safeIndex = min(
            max(selectedIndex, 0),
            itemCount - 1
        )

        return CGFloat(safeIndex) / CGFloat(itemCount - 1)
    }

    var body: some View {
        GlassEffectContainer {
            if itemCount > 0 {
                GeometryReader { proxy in
                    content(
                        width: proxy.size.width,
                        height: proxy.size.height
                    )
                }
                .frame(height: HorizontalPagerBarLayout.height)
                .padding(.horizontal, HorizontalPagerBarLayout.horizontalPadding)
            }
        }
    }

    private func content(
        width: CGFloat,
        height: CGFloat
    ) -> some View {
        HStack(spacing: 0) {
            ForEach(0..<itemCount, id: \.self) { index in
                item(index)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(.capsule)
                    .onTapGesture {
                        onSelectIndex(index)
                    }
            }
        }
        .pagerMask(
            pageProgress: resolvedTabProgress,
            itemCount: itemCount
        )
        .background {
            movingSelectionCapsule(
                width: width,
                height: height
            )
        }
        .background(backgroundColor, in: .capsule)
        .clipShape(Capsule())
        .glassEffect(.regular, in: .capsule)
    }

    private var backgroundColor: Color {
        scheme == .dark
        ? Color(.secondarySystemGroupedBackground).opacity(0.45)
        : Color(.systemBackground).opacity(0.35)
    }

    private var selectionCapsuleColor: Color {
        scheme == .dark
        ? Color.white.opacity(0.18)
        : Color.gray.opacity(0.1)
    }

    private func movingSelectionCapsule(
        width: CGFloat,
        height: CGFloat
    ) -> some View {
        let metrics = PagerCapsuleMetrics(
            totalWidth: width,
            totalHeight: height,
            itemCount: itemCount,
            progress: resolvedTabProgress
        )

        return ZStack {
            if metrics.isValid {
                Capsule()
                    .fill(selectionCapsuleColor)
                    .shadow(
                        color: .black.opacity(scheme == .dark ? 0.18 : 0.06),
                        radius: 6,
                        x: 0,
                        y: 2
                    )
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
