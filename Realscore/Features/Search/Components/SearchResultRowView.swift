//
//  SearchResultRowView.swift
//  Realscore
//

import SwiftUI

struct SearchResultRowView: View {
    let result: SearchResult

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline) {
                Text(result.title)
                    .font(.headline)

                Spacer()

                if !result.season.isEmpty {
                    Text(result.season)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            if !result.subtitle.isEmpty {
                Text(result.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
