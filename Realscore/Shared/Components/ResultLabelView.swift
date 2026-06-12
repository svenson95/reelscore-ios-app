//
//  ResultLabelView.swift
//  Realscore
//

import SwiftUI

struct ResultLabelView: View {
    let fixture: Fixture
    let showNotPlayedText: Bool

    init(
        fixture: Fixture,
        showNotPlayedText: Bool = false
    ) {
        self.fixture = fixture
        self.showNotPlayedText = showNotPlayedText
    }

    @ViewBuilder
    var body: some View {
        if isPenaltyShootout {
            HStack(spacing: 4) {
                Text("n.E.")
                    .font(.caption)

                Text("\(penaltyResult.home.formattedGoal):\(penaltyResult.away.formattedGoal)")
            }
        } else {
            HStack(spacing: 4) {
                Text(mainResult.home.formattedGoal)

                if !separatorText.isEmpty {
                    Text(separatorText)
                }

                Text(mainResult.away.formattedGoal)
            }
        }
    }

    private var mainResult: Goals {
        fixture.goals
    }

    private var penaltyResult: Goals {
        fixture.score.penalty
    }

    private var status: FixtureStatus {
        fixture.fixture.status
    }

    private var isScheduled: Bool {
        Self.scheduledStatuses.contains(status.short)
    }

    private var isPenaltyShootout: Bool {
        status.short == "P"
    }

    private var isNotPlayed: Bool {
        let statusShort = status.short

        return statusShort == Self.postponedStatus ||
            statusShort == Self.cancelledStatus ||
            statusShort == Self.abandonedStatus
    }

    private var separatorText: String {
        if isNotPlayed {
            return showNotPlayedText ? "" : "－"
        }

        if isScheduled {
            return "vs"
        }

        return ":"
    }

    private static let scheduledStatuses: Set<String> = [
        "TBD",
        "NS"
    ]

    private static let postponedStatus = "PST"
    private static let cancelledStatus = "CANC"
    private static let abandonedStatus = "ABD"
}

private extension Optional where Wrapped == Int {
    var formattedGoal: String {
        guard let self else {
            return ""
        }

        return String(self)
    }
}
