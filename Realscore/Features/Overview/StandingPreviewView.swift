//
//  StandingPreviewView.swift
//  Realscore
//

import SwiftUI

struct StandingPreviewView: View {
    let standings: [Standing]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeaderView(title: "Top 5")

            ForEach(standings) { standing in
                HStack {
                    Text("\(standing.position).")
                        .foregroundStyle(.secondary)
                    Text(standing.team.name)
                    Spacer()
                    Text("\(standing.points ?? 0)")
                        .bold()
                }
                .font(.subheadline)
            }
        }
    }
}
