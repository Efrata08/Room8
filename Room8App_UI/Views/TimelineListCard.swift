//
//  TimelineListCard.swift
//  Room8App_UI
//
//  Created by ktnguyenx on 2/8/26.
//

import SwiftUI

struct CalendarItem: Identifiable {
    let id = UUID()
    var title: String
    var subtitle: String
    var dotColor: Color
    var isDone: Bool = false
}

struct TimelineListCard: View {
    @State private var items: [CalendarItem] = [
        .init(title: "Wash dishes", subtitle: "Chore • You", dotColor: Theme.sage),
        .init(title: "House meeting", subtitle: "Event • 7:00 PM", dotColor: Theme.terracotta),
        .init(title: "Clean bathroom", subtitle: "Chore • Fatma Ayad", dotColor: Theme.sage),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            TimelineSection(title: "Today") {
                TimelineItem(title: "Wash dishes", type: "Chore", person: "You", time: nil)
                TimelineItem(title: "House meeting", type: "Event", person: nil, time: "7:00 PM")
            }

            Divider().opacity(0.15)

            TimelineSection(title: "Feb 14") {
                TimelineItem(title: "Clean bathroom", type: "Chore", person: "Fatma Ayad", time: nil)
            }

            Divider().opacity(0.15)

            TimelineSection(title: "Feb 15") {
                TimelineItem(title: "Grocery shopping", type: "Event", person: "Kashaf Batool", time: "2:00 PM")
            }
        }
        .padding(16)
        .background(Theme.white)
        .cornerRadius(Theme.cornerXL)
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 6)
    }
}

private struct TimelineSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Theme.black.opacity(0.65))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Theme.sand.opacity(0.65))
                .cornerRadius(14)

            content
        }
    }
}

private struct TimelineItem: View {
    let title: String
    let type: String
    let person: String?
    let time: String?

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)

                HStack(spacing: 10) {
                    Text(type)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(type == "Chore" ? Theme.sage : Theme.terracotta)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background((type == "Chore" ? Theme.sage : Theme.terracotta).opacity(0.12))
                        .cornerRadius(12)

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

                    if let person {
                        HStack(spacing: 6) {
                            Image(systemName: "person")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.black.opacity(0.55))
                            Text(person)
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
        .background(Theme.white)
        .cornerRadius(Theme.cornerXL)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cornerXL)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
    }
}
