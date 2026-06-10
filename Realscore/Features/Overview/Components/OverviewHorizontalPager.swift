//
//  OverviewHorizontalPager.swift
//  Realscore
//

import SwiftUI

struct OverviewHorizontalPager<Content: View>: View {
    let pageIDs: [Int]
    @Binding var selectedPage: Int
    let isDisabled: Bool
    @ViewBuilder let content: (Int) -> Content

    @State private var isHorizontalPaging = false
    @State private var previousPage: Int?

    private var scrollPosition: Binding<Int?> {
        Binding<Int?>(
            get: {
                guard pageIDs.contains(selectedPage) else {
                    return pageIDs.first
                }

                return selectedPage
            },
            set: { newValue in
                guard let newValue else { return }
                guard pageIDs.contains(newValue) else { return }

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
                            .environment(\.isScrollEnabled, !isHorizontalPaging)
                            .id(pageID)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: scrollPosition)
            .disabled(isDisabled)
            .simultaneousGesture(
                DragGesture(minimumDistance: 8)
                    .onChanged { value in
                        let horizontal = abs(value.translation.width)
                        let vertical = abs(value.translation.height)

                        if horizontal > vertical {
                            isHorizontalPaging = true
                        }
                    }
                    .onEnded { _ in
                        isHorizontalPaging = false
                    }
            )
            .onAppear {
                previousPage = selectedPage
            }
            .onChange(of: selectedPage) { oldValue, newValue in
                isHorizontalPaging = false
                previousPage = newValue
            }
        }
    }
}
