//
//  AppColors.swift
//  Realscore
//

import SwiftUI

enum AppColors {
    static let background = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let accent = Color("AccentColor")
    
    static func timeText(status: FixtureStatusShort) -> Color {
        return status.isEnded ? .secondary : .primary
    }

    static func timeBackground(status: FixtureStatusShort) -> AnyShapeStyle {
        if status.isPlaying || status.isHalftime {
            AnyShapeStyle(.green.secondary)
        } else if status.isScheduled {
            AnyShapeStyle(FixtureRowStyle.grayBadgeColor)
        } else {
            AnyShapeStyle(Color(.systemBackground))
        }
    }
}
