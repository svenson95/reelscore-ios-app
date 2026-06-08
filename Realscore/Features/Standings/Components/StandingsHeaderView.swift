//
//  StandingsHeader.swift
//  Realscore
//

import SwiftUI

struct StandingsHeaderView: View {
    let RANK_COL_WIDTH = TableConstants.RANK_COL_WIDTH
    let NUMBER_ROW_WIDTH = TableConstants.NUMBER_ROW_WIDTH
    let HSTACK_SPACING = TableConstants.HSTACK_SPACING

    var body: some View {
        HStack(spacing: HSTACK_SPACING) {
            Text("#")
                .frame(width: RANK_COL_WIDTH, alignment: .leading)

            Text("Team")
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Sp")
                .frame(width: NUMBER_ROW_WIDTH, alignment: .center)

            Text("S")
                .frame(width: NUMBER_ROW_WIDTH, alignment: .center)

            Text("U")
                .frame(width: NUMBER_ROW_WIDTH, alignment: .center)

            Text("N")
                .frame(width: NUMBER_ROW_WIDTH, alignment: .center)

            Text("Pkt")
                .frame(width: NUMBER_ROW_WIDTH, alignment: .center)
        }
        .font(.caption)
        .foregroundStyle(.secondary)
    }
}
