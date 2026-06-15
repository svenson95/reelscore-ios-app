//
//  AppColors.swift
//  Realscore
//

import SwiftUI

enum AppColors {
    static let background = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let accent = Color("AccentColor")
    static let gray = Color.gray.opacity(0.15);
    
    static func badgeText(status: FixtureStatusShort) -> Color {
        return status.isEnded ? .secondary : .primary
    }

    static func badgeBackground(status: FixtureStatusShort, isMatchPage: Bool = false) -> AnyShapeStyle {
        if status.isPlaying || status.isHalftime {
            AnyShapeStyle(.green.secondary)
        } else if status.isScheduled {
            AnyShapeStyle(gray)
        } else {
            AnyShapeStyle(isMatchPage ? Color(.systemBackground) : Color(.clear))
        }
    }
}
