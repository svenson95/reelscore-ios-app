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
        pickerCard
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.clear)
    }

    private var pickerCard: some View {
        VStack(spacing: 12) {
            header

            DatePicker(
                "Datum auswählen",
                selection: $draftDate,
                in: dateRange,
                displayedComponents: .date
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
                    .background(Color(.tertiarySystemBackground))
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
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    private var dateRange: ClosedRange<Date> {
        let calendar = Calendar.appCalendar

        let startParts = Constants.DATA_START_DATE.split(separator: "-").compactMap { Int($0) }
        let minDate = calendar.date(from: DateComponents(
            year: startParts[0],
            month: startParts[1],
            day: startParts[2]
        ))!

        let endParts = Constants.DATA_END_DATE.split(separator: "-").compactMap { Int($0) }
        let maxDate = calendar.date(from: DateComponents(
            year: endParts[0],
            month: endParts[1],
            day: endParts[2]
        ))!

        return minDate...maxDate
    }
}
