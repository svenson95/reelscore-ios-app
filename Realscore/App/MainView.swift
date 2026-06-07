//
//  MainView.swift
//  Realscore
//

import SwiftUI

enum MainTab: Hashable {
    case overview
    case competitions
    case search
}

struct MainView: View {
    @State private var selectedTab: MainTab = .overview

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(value: MainTab.overview) {
                NavigationStack {
                    OverviewView()
                }
            } label: {
                Label("Überblick", systemImage: "list.bullet")
            }

            Tab(value: MainTab.competitions) {
                NavigationStack {
                    CompetitionSelectView()
                }
            } label: {
                Label("Wettbewerbe", systemImage: "trophy")
            }

            Tab(value: MainTab.search, role: .search) {
                NavigationStack {
                    SearchView()
                }
            } label: {
                Label("Suche", systemImage: "magnifyingglass")
            }
        }
    }
}

#Preview {
    MainView()
}
