//
//  HorizontalPagerBar.swift
//  Realscore
//

import SwiftUI

enum HorizontalPagerBarLayout {
    static let height: CGFloat = 50
    static let horizontalPadding: CGFloat = 15
    static let bottomPadding: CGFloat = 0
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
        if let tabProgress {
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
                    content(width: proxy.size.width)
                }
                .frame(height: HorizontalPagerBarLayout.height)
                .padding(.horizontal, HorizontalPagerBarLayout.horizontalPadding)
                .padding(.bottom, HorizontalPagerBarLayout.bottomPadding)
            }
        }
    }

    private func content(width: CGFloat) -> some View {
        HStack(spacing: 0) {
            ForEach(0..<itemCount, id: \.self) { index in
                item(index)
                    .frame(maxWidth: .infinity, minHeight: 30)
                    .padding(.vertical, 10)
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
            movingSelectionCapsule(width: width)
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

    private func movingSelectionCapsule(width: CGFloat) -> some View {
        let baseCapsuleWidth = capsuleWidth(totalWidth: width)
        let horizontalInset: CGFloat = PagerLayout.CAPSULE_INSET
        let verticalInset: CGFloat = PagerLayout.CAPSULE_INSET

        let visibleCapsuleWidth = max(baseCapsuleWidth - horizontalInset, 0)
        let visibleCapsuleHeight = max(HorizontalPagerBarLayout.height - verticalInset, 0)
        let travelDistance = max(width - baseCapsuleWidth, 0)

        return Capsule()
            .fill(selectionCapsuleColor)
            .shadow(
                color: .black.opacity(scheme == .dark ? 0.18 : 0.06),
                radius: 6,
                x: 0,
                y: 2
            )
            .frame(
                width: visibleCapsuleWidth,
                height: visibleCapsuleHeight
            )
            .offset(
                x: resolvedTabProgress * travelDistance - travelDistance / 2
            )
    }

    private func capsuleWidth(totalWidth: CGFloat) -> CGFloat {
        guard itemCount > 0 else { return 0 }

        return totalWidth / CGFloat(itemCount)
    }
}
