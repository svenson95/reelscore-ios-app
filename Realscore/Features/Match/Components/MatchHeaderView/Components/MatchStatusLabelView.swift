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

    private var isPlayingStyle: Bool {
        state.isPenalty || state.isHalftime || state.isPlaying
    }

    var body: some View {
        if !label.isEmpty {
            Text(label)
                .font(.caption2.weight(isPlayingStyle ? .semibold : .regular))
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background {
                    if isPlayingStyle {
                        Color.green
                    } else {
                        Color(.systemBackground)
                    }
                }
                .foregroundStyle(
                    isPlayingStyle ? Color(.systemBackground) :
                        state.status.isEnded ?
                        .secondary : .primary
                )
                .cornerRadius(6)
        }
    }
}
