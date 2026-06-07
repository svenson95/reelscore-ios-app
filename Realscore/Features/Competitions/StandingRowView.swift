//
//  StandingRowView.swift
//  Realscore
//

import SwiftUI

struct StandingRowView: View {
    let standing: Standing

    var body: some View {
        HStack(spacing: 12) {
            Text("\(standing.position)")
                .frame(width: 28, alignment: .leading)
                .foregroundStyle(.secondary)

            Text(standing.team.name)

            Spacer()

            if let played = standing.played {
                Text("\(played)")
                    .foregroundStyle(.secondary)
            }

            Text("\(standing.points ?? 0)")
                .bold()
                .frame(width: 32, alignment: .trailing)
        }
    }
}
