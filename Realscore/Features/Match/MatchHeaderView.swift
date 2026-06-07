//
//  MatchHeaderView.swift
//  Realscore
//

import SwiftUI

struct MatchHeaderView: View {
    let fixture: Fixture

    var body: some View {
        VStack(spacing: 12) {
            Text(fixture.displayName)
                .font(.title3.bold())
                .multilineTextAlignment(.center)

            Text(fixture.league.name)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }
}
