//
//  ErrorView.swift
//  Realscore
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let isRetrying: Bool
    let retry: (() -> Void)?

    init(
        message: String,
        isRetrying: Bool = false,
        retry: (() -> Void)? = nil
    ) {
        self.message = message
        self.isRetrying = isRetrying
        self.retry = retry
    }

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.title2)

            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            if let retry {
                Button {
                    retry()
                } label: {
                    if isRetrying {
                        HStack(spacing: 8) {
                            ProgressView()
                            Text("Lädt neu...")
                        }
                    } else {
                        Text("Erneut versuchen")
                    }
                }
                .buttonStyle(.bordered)
                .disabled(isRetrying)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
