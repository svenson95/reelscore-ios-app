//
//  FixtureSectionHeaderView.swift
//  Realscore
//

import SwiftUI

struct FixtureSectionHeaderView: View {
    // Users/svenbrodny/Developer/Swift/Realscore/Realscore/Features/Overview/Components/FixtureSectionHeaderView.swift:9:16 'FixtureSectionGroup' is ambiguous for type lookup in this context

    let group: FixtureSectionGroup

    var body: some View {
        HStack(spacing: 12) {
            competitionLogo

            Text(group.competition)
                .font(.default)
                .fontWeight(.semibold)
                .lineLimit(1)

            Spacer()

            Text(group.round)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .textCase(nil)
    }

    @ViewBuilder
    private var competitionLogo: some View {
        if let logo = group.competitionLogo,
           let url = URL(string: logo) {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Color.clear
            }
            .frame(width: 24, height: 24)
        }
    }
}
