//
//  View+Extensions.swift
//  Realscore
//

import SwiftUI

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

    @ViewBuilder
    func weekdayTabMask(
        _ tabProgress: CGFloat,
        tabCount: Int
    ) -> some View {
        ZStack {
            self
                .foregroundStyle(.secondary)

            self
                .foregroundStyle(.accent)
                .fontWeight(.semibold)
                .mask {
                    GeometryReader { proxy in
                        let size = proxy.size
                        let capsuleWidth = tabCount > 0
                            ? size.width / CGFloat(tabCount)
                            : 0

                        Capsule()
                            .frame(width: capsuleWidth)
                            .offset(
                                x: tabProgress * max(size.width - capsuleWidth, 0)
                            )
                    }
                }
        }
    }
}
