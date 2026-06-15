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
    
    @Environment(\.colorScheme) private var colorScheme

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

            datePickerContainer
                .frame(height: 330)

            footer
        }
        .padding()
        .frame(width: 360, height: 440, alignment: .top)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppLayout.cornerRadius, style: .continuous))
        .shadow(radius: 24)
        .padding(.horizontal, AppLayout.large)
        .transaction { transaction in
            transaction.animation = nil
        }
    }

    private var datePickerContainer: some View {
        ZStack(alignment: .top) {
            DatePicker(
                "Datum auswählen",
                selection: $draftDate,
                in: Self.dateRange,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .labelsHidden()
            .environment(\.locale, .appLocale)
            .environment(\.calendar, .appCalendar)
            .frame(width: 328, height: 330, alignment: .top)
        }
        .frame(width: 328, height: 330, alignment: .top)
        .clipped()
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
    
    private static let dateRange: ClosedRange<Date> = {
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
    }()
    
    private var cardBackground: Color {
        colorScheme == .dark
            ? Color(uiColor: .secondarySystemBackground)
            : Color(uiColor: .secondarySystemGroupedBackground)
    }
}
