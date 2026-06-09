//
//  OverviewDatePickerOverlay.swift
//  Realscore
//

import SwiftUI

struct OverviewDatePickerOverlay: View {
    @Binding var selectedDate: Date

    let onSelectDate: (Date) -> Void
    let onDismiss: () -> Void

    @State private var draftDate: Date

    init(
        selectedDate: Binding<Date>,
        onSelectDate: @escaping (Date) -> Void,
        onDismiss: @escaping () -> Void
    ) {
        self._selectedDate = selectedDate
        self.onSelectDate = onSelectDate
        self.onDismiss = onDismiss
        self._draftDate = State(initialValue: selectedDate.wrappedValue)
    }

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
                selection: $draftDate,
                displayedComponents: .date,
            )
            .datePickerStyle(.graphical)
            .labelsHidden()
            .environment(\.locale, .appLocale)
            .environment(\.calendar, .appCalendar)

            footer
        }
        .padding()
        .frame(maxWidth: 360)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(radius: 24)
        .padding(.horizontal, 16)
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

    private var footer: some View {
        HStack {
            Button("Abbrechen") {
                onDismiss()
            }
            .buttonStyle(.bordered)

            Spacer()

            Button("Übernehmen") {
                selectedDate = draftDate
                onSelectDate(draftDate)
                onDismiss()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
