//
//  CompetitionLogoView.swift
//  Realscore
//

import SwiftUI
import UIKit

struct CompetitionLogoView: View {
    let competitionId: Int?
    let size: CGFloat

    var body: some View {
        Group {
            if let competitionId,
               UIImage(named: assetName(for: competitionId)) != nil {
                Image(assetName(for: competitionId))
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "trophy")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: size, height: size)
    }

    private func assetName(for competitionId: Int) -> String {
        "competition_\(competitionId)"
    }
}
