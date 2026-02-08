//
//  AddToCalendarSheet.swift
//  Room8App_UI
//
//  Created by ktnguyenx on 2/8/26.
//

import SwiftUI

enum AddCalendarType: Hashable {
    case event
    case chore
}

struct AddToCalendarSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var type: AddCalendarType = .event

    @State private var name: String = ""
    @State private var date: Date = Date()
    @State private var timeEnabled: Bool = false
    @State private var time: Date = Date()

    @State private var assignedTo: String = "Select roommate"
    private let roommates = ["Select roommate", "You", "Fatma Ayad", "Kashaf Batool", "Efrata"]

    var body: some View {
        VStack(spacing: 18) {

            // more space above title
            Spacer().frame(height: 16)

            header

            AddTypeToggle(type: $type)

            VStack(alignment: .leading, spacing: 12) {

                Text(type == .event ? "Event Name" : "Chore Name")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.navy.opacity(0.85))

                pillTextField(
                    placeholder: type == .event ? "e.g., Movie night" : "e.g., Clean kitchen",
                    text: $name
                )

                Text("Date")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.navy.opacity(0.85))

                pillDatePicker(date: $date)

                Text("Time (optional)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.navy.opacity(0.85))

                VStack(spacing: 10) {
                    Toggle(isOn: $timeEnabled) {
                        Text("Add a time")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.black.opacity(0.75))
                    }
                    .tint(Theme.sage.opacity(0.9))

                    if timeEnabled {
                        pillTimePicker(time: $time)
                    }
                }

                if type == .chore {
                    Text("Assign to")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.navy.opacity(0.85))

                    Menu {
                        ForEach(roommates, id: \.self) { n in
                            Button { assignedTo = n } label: { Text(n) }
                        }
                    } label: {
                        HStack {
                            Text(assignedTo)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(assignedTo == "Select roommate" ? .black.opacity(0.45) : .black.opacity(0.80))
                            Spacer()
                            Image(systemName: "chevron.down")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.black.opacity(0.45))
                        }
                        .padding(.horizontal, 18)
                        .frame(height: 54)
                        .background(Theme.sand.opacity(0.65))
                        .cornerRadius(Theme.cornerXL)
                    }
                }

                Button {
                    // TODO: backend later
                    dismiss()
                } label: {
                    Text(type == .event ? "Add Event" : "Add Chore")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Theme.terracotta.opacity(0.9))
                        .cornerRadius(Theme.cornerXL)
                }
                .buttonStyle(.plain)
                .padding(.top, 8)

            }
            .padding(.horizontal, 18)

            Spacer()
        }
        .padding(.top, 14)
        .background(Theme.white.ignoresSafeArea())
    }

    // MARK: - Header (NO subtitle / caption)

    private var header: some View {
        HStack(alignment: .top) {
            Text("Add to Calendar")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(Theme.navy)

            Spacer()

            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Theme.navy.opacity(0.75))
                    .frame(width: 36, height: 36)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(12)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 18)
        .padding(.top, 6)
    }

    // MARK: - Pills

    private func pillTextField(placeholder: String, text: Binding<String>) -> some View {
        TextField(placeholder, text: text)
            .padding(.horizontal, 18)
            .frame(height: 54)
            .background(Theme.sand.opacity(0.65))
            .cornerRadius(Theme.cornerXL)
    }

    private func pillDatePicker(date: Binding<Date>) -> some View {
        DatePicker("", selection: date, displayedComponents: [.date])
            .datePickerStyle(.compact)
            .labelsHidden()
            .padding(.horizontal, 18)
            .frame(height: 54)
            .background(Theme.sand.opacity(0.65))
            .cornerRadius(Theme.cornerXL)
    }

    private func pillTimePicker(time: Binding<Date>) -> some View {
        DatePicker("", selection: time, displayedComponents: [.hourAndMinute])
            .datePickerStyle(.compact)
            .labelsHidden()
            .padding(.horizontal, 18)
            .frame(height: 54)
            .background(Theme.sand.opacity(0.65))
            .cornerRadius(Theme.cornerXL)
    }
}

// MARK: - Toggle (outside AddToCalendarSheet)

struct AddTypeToggle: View {
    @Binding var type: AddCalendarType

    var body: some View {
        HStack(spacing: 0) {
            button(title: "Event", isSelected: type == .event) { type = .event }
            button(title: "Chore", isSelected: type == .chore) { type = .chore }
        }
        .padding(6)
        .background(Theme.sand.opacity(0.55))
        .cornerRadius(Theme.cornerXL)
        .padding(.horizontal, 18)
    }

    private func button(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isSelected ? Theme.navy : Theme.navy.opacity(0.75))
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(isSelected ? Theme.white : Color.clear)
                .cornerRadius(Theme.cornerL)
        }
        .buttonStyle(.plain)
    }
}

