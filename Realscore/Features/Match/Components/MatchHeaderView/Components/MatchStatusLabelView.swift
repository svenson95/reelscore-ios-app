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

        if state.isPenalty {
            return "Elfmeterschießen"
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
                .font(.caption2.weight(isPlaying ? .semibold : .regular))
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background {
                    RoundedRectangle(cornerRadius: AppLayout.cornerRadiusSmall)
                        .fill(AppColors.timeBackground(status: state.status))
                }
                .foregroundStyle(AppColors.timeText(status: state.status))
        }
    }
}
