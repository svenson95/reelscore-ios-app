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
    let teamId: Int?
    let size: TeamLogoSize

    var body: some View {
        Group {
            if let teamId,
                UIImage(named: assetName(for: teamId)) != nil
            {
                Image(assetName(for: teamId))
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "shield")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(width: size.cgFloat, height: size.cgFloat)
            }
        }
        .frame(width: size.cgFloat, height: size.cgFloat)
    }

    private func assetName(for teamId: Int) -> String {
        return "team_logo_\(size)x\(size)_\(teamId)"
    }
}
