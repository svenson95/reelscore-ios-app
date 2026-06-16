//
//  TeamLogoView.swift
//  Realscore
//

import SwiftUI

enum TeamLogoSize: Int {
    case small = 14
    case large = 48

    var cgFloat: CGFloat {
        CGFloat(rawValue)
    }
}

struct TeamLogoView: View {
    let teamId: Int
    let size: TeamLogoSize

    var body: some View {
        Group {
            if UIImage(named: assetName(for: teamId)) != nil {
                Image(assetName(for: teamId))
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "shield")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: size.cgFloat, height: size.cgFloat)
    }

    private func assetName(for teamId: Int) -> String {
        return "team_logo_\(size.rawValue)x\(size.rawValue)_\(teamId)"
    }
}
