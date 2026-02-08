//
//  TodayScheduleCard.swift
//  Room8App_UI
//
//  Created by ktnguyenx on 2/8/26.
//

import SwiftUI

struct TodayScheduleCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Today’s Schedule")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Theme.black)

            ScheduleRow(title: "Wash dishes", tag: "Chore", person: "You", time: nil)
        }
        .padding(16)
        .background(Theme.white)
        .cornerRadius(Theme.cornerXL)
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 6)
    }
}

private struct ScheduleRow: View {
    let title: String
    let tag: String
    let person: String
    let time: String?

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)

                HStack(spacing: 10) {
                    Text(tag)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Theme.sage)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Theme.sage.opacity(0.12))
                        .cornerRadius(12)

                    HStack(spacing: 6) {
                        Image(systemName: "person")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.black.opacity(0.55))
                        Text(person)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.black.opacity(0.75))
                    }

                    if let time {
                        HStack(spacing: 6) {
                            Image(systemName: "clock")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.black.opacity(0.55))
                            Text(time)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.black.opacity(0.75))
                        }
                    }
                }
            }

            Spacer()

            Circle()
                .strokeBorder(Color.black.opacity(0.20), lineWidth: 2)
                .frame(width: 22, height: 22)
        }
        .padding(16)
        .background(Theme.sand.opacity(0.45))
        .cornerRadius(Theme.cornerXL)
    }
}
