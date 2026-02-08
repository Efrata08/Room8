//
//  CalendarMonthCard.swift
//  Room8App_UI
//
//  Created by ktnguyenx on 2/8/26.
//

import SwiftUI

struct CalendarMonthCard: View {
    @State private var monthTitle: String = "February 2026"

    var body: some View {
        VStack(spacing: 14) {
            HStack {
                Button { } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Theme.navy.opacity(0.8))
                }
                .buttonStyle(.plain)

                Spacer()

                Text(monthTitle)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Theme.black)

                Spacer()

                Button { } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Theme.navy.opacity(0.8))
                }
                .buttonStyle(.plain)
            }

            Button {
                // TODO: scroll/return to today date later
            } label: {
                Text("Today")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Theme.sage.opacity(0.85))
                    .cornerRadius(18)
            }
            .buttonStyle(.plain)

            // Placeholder “calendar grid” — we’ll replace with real calendar later
            RoundedRectangle(cornerRadius: Theme.cornerXL)
                .fill(Color.black.opacity(0.04))
                .frame(height: 240)
                .overlay(
                    Text("Calendar grid goes here")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black.opacity(0.35))
                )
        }
        .padding(16)
        .background(Theme.white)
        .cornerRadius(Theme.cornerXL)
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 6)
    }
}
