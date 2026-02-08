//
//  CalendarRootView.swift
//  Room8App_UI
//
//  Created by ktnguyenx on 2/8/26.
//

import SwiftUI

enum CalendarMode: Hashable {
    case calendar
    case timeline
}

struct CalendarRootView: View {
    @State private var mode: CalendarMode = .calendar
    @State private var showAddSheet = false

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 18) {
                    header

                    CalendarModeToggle(mode: $mode)

                    Group {
                        switch mode {
                        case .calendar:
                            CalendarMonthCard()
                            TodayScheduleCard()
                        case .timeline:
                            TimelineListCard()
                        }
                    }

                    Spacer(minLength: 24)
                }
                .padding(.horizontal, Theme.pad)
                .padding(.top, 16)
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddToCalendarSheet()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }

    private var header: some View {
        HStack(alignment: .center) {
            Text("Calendar")
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(Theme.navy)

            Spacer()

            Button {
                showAddSheet = true
            } label: {
                Circle()
                    .fill(Theme.sage.opacity(0.85))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    )
            }
            .buttonStyle(.plain)
        }
    }
}
