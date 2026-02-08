//
//  CalendarModeToggle.swift
//  Room8App_UI
//
//  Created by ktnguyenx on 2/8/26.
//

import SwiftUI

struct CalendarModeToggle: View {
    @Binding var mode: CalendarMode

    var body: some View {
        HStack(spacing: 0) {
            toggleButton(
                title: "Calendar",
                systemImage: "calendar",
                isSelected: mode == .calendar
            ) {
                mode = .calendar
            }

            toggleButton(
                title: "Timeline",
                systemImage: "list.bullet",
                isSelected: mode == .timeline
            ) {
                mode = .timeline
            }
        }
        .padding(6)
        .background(Theme.sand.opacity(0.65))
        .cornerRadius(Theme.cornerXL)
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 5)
    }

    private func toggleButton(title: String, systemImage: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .font(.system(size: 14, weight: .semibold))
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(isSelected ? Theme.navy : Theme.navy.opacity(0.75))
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(isSelected ? Theme.white : Color.clear)
            .cornerRadius(Theme.cornerL)
        }
        .buttonStyle(.plain)
    }
}
