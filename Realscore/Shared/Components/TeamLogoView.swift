//
//  TeamLogoView.swift
//  Realscore
//

import SwiftUI

struct TeamLogoView: View {
    let teamId: Int?
    let size: CGFloat

    var body: some View {
        Group {
            if let teamId,
               UIImage(named: assetName(for: teamId)) != nil {
                Image(assetName(for: teamId))
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "shield")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: size, height: size)
    }

    private func assetName(for teamId: Int) -> String {
        "team_\(teamId)"
    }
}
