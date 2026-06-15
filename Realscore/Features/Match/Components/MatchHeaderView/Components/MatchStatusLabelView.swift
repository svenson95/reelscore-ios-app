//
//  MatchStatusLabelView.swift
//  Realscore
//

import SwiftUI

struct MatchStatusLabelView: View {
    let fixture: Fixture

    private var state: FixtureStatusState {
        FixtureStatusStateMapper.state(for: fixture.fixture.status.short)
    }

    private var label: String {
        if state.isNotPlayed {
            return "Abgesagt"
        }

        if state.isHalftime {
            return "HZ"
        }

        if state.isPlaying {
            if state.status == "INT" {
                return "Unterbrechung"
            }

            let elapsed = fixture.fixture.status.elapsed ?? 0
            let extra = fixture.fixture.status.extra ?? 0

            return "\(elapsed + extra)'"
        }

        if state.isFinished {
            return "ENDE"
        }

        return ""
    }

    private var isPlaying: Bool {
        state.isPlaying || state.isHalftime
    }

    var body: some View {
        if !label.isEmpty {
            Text(label)
                .frame(minWidth: 42, alignment: .center)
                .padding(.horizontal, AppLayout.badgePaddingHorizontal)
                .padding(.vertical, AppLayout.badgePaddingVertical)
                .background(AppColors.badgeBackground(status: state.status, isMatchPage: true))
                .cornerRadius(AppLayout.cornerRadiusSmall)
                .font(.caption2.weight(isPlaying ? .semibold : .regular))
                .foregroundStyle(AppColors.badgeText(status: state.status))
        }
    }
}
