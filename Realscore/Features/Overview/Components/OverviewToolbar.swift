//
//  OverviewToolbar.swift
//  Realscore
//

import SwiftUI

struct OverviewToolbar: ToolbarContent {
    let dateText: String
    let showsTodayButton: Bool
    let onDateTap: () -> Void
    let onToday: () -> Void

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                onDateTap()
            } label: {
                Text(dateText)
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
            }
        }

        ToolbarItem(placement: .topBarTrailing) {
            if showsTodayButton {
                Button("Heute") {
                    onToday()
                }
            }
        }
    }
}
