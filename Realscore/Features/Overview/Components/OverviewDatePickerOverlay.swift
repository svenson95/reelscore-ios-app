//
//  OverviewDatePickerOverlay.swift
//  Realscore
//

import SwiftUI

struct OverviewDatePickerOverlay: View {
    @Binding var selectedDate: Date

    let onSelectDate: (Date) -> Void
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            backdrop
            pickerCard
        }
        .transition(.opacity.combined(with: .scale(scale: 0.96)))
    }

    private var backdrop: some View {
        Color.black.opacity(0.35)
            .ignoresSafeArea()
            .onTapGesture {
                onDismiss()
            }
    }

    private var pickerCard: some View {
        VStack(spacing: 12) {
            header

            DatePicker(
                "Datum auswählen",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .labelsHidden()
            .onChange(of: selectedDate) { _, newDate in
                onSelectDate(newDate)
            }
        }
        .padding()
        .frame(maxWidth: 360)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(radius: 24)
        .padding(.horizontal, 24)
    }

    private var header: some View {
        HStack {
            Text("Datum auswählen")
                .font(.headline)

            Spacer()

            Button {
                onDismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(8)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
    }
}
