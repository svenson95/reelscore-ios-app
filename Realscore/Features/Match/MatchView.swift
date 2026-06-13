//
//  MatchView.swift
//  Realscore
//

import SwiftUI

struct MatchView: View {
    @StateObject private var viewModel: MatchViewModel

    @State private var selectedTab: MatchTab = .details
    @State private var headerHeight: CGFloat = 0

    init(fixture: Fixture) {
        _viewModel = StateObject(wrappedValue: MatchViewModel(fixture: fixture))
    }

    var body: some View {
        ZStack(alignment: .top) {
            content

            MatchHeaderView(fixture: viewModel.fixture)
                .readHeight { height in
                    guard abs(headerHeight - height) > 0.5 else { return }
                    headerHeight = height
                }
                .zIndex(1)
                .padding(.horizontal, AppLayout.large)
        }
        .navigationTitle("Partie")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var content: some View {
        HorizontalPagerWithBar(
            pageIDs: MatchTab.allCases,
            selectedPage: $selectedTab,
            barTopSpacing: headerHeight + AppLayout.large
        ) { tab in
            tabBarItem(tab)
        } pageContent: { tab in
            pageContent(for: tab)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    private func tabBarItem(_ tab: MatchTab) -> some View {
        VStack(spacing: 2) {
            Image(systemName: tab.systemImage)

            Text(tab.rawValue)
                .font(.caption2)
                .lineLimit(1)
        }
    }

    @ViewBuilder
    private func pageContent(for tab: MatchTab) -> some View {
        switch tab {
        case .details:
            detailsPage

        case .analyses:
            placeholder("Analysen ...")

        case .events:
            placeholder("Events ...")

        case .statistics:
            placeholder("Statistiken ...")
        }
    }

    private var detailsPage: some View {
        ScrollView(.vertical) {
            MatchDetails(fixture: viewModel.fixture)
                .padding(15)
                .frame(maxWidth: .infinity)
        }
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
    }

    private func placeholder(_ title: String) -> some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.title3.weight(.semibold))

            Text("Hier kannst du später den Inhalt einfügen.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

private struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private extension View {
    func readHeight(_ onChange: @escaping (CGFloat) -> Void) -> some View {
        self.onGeometryChange(for: CGFloat.self) { proxy in
            proxy.size.height
        } action: { height in
            guard height > 0 else { return }
            onChange(height)
        }
    }
}

#Preview {
    MatchView(fixture: FixtureMock.example)
}
