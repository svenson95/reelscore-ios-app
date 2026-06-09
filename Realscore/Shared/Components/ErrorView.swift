//
//  ErrorView.swift
//  Realscore
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let retry: (() -> Void)?

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.title2)

            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            if let retry {
                Button("Erneut versuchen") {
                    retry()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
