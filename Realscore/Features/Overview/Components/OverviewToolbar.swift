//
//  OverviewToolbar.swift
//  Realscore
//

import SwiftUI

struct OverviewToolbar: ToolbarContent {
    let dateText: String
    let showsTodayButton: Bool
    let onToday: () -> Void

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                // TODO: DatePicker öffnen
            } label: {
                Text(dateText)
                    .font(.subheadline.weight(.semibold))
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
