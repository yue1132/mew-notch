//
//  CalendarHUDRightView.swift
//  MewNotch
//
//  Right side calendar HUD - shows next event title
//

import SwiftUI

struct CalendarHUDRightView: View {

    @ObservedObject var notchViewModel: NotchViewModel
    @ObservedObject private var calendarManager = CalendarManager.shared
    @StateObject private var calendarDefaults = CalendarDefaults.shared

    var body: some View {
        if calendarDefaults.showInNotch,
           let nextEvent = nextUpcomingEvent {
            Button {
                if let url = URL(string: "x-apple-calevent://\(nextEvent.eventIdentifier ?? "")") {
                    NSWorkspace.shared.open(url)
                } else {
                    NSWorkspace.shared.open(URL(string: "x-apple-calevent://")!)
                }
            } label: {
                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: 8)

                    Text(nextEvent.title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .fixedSize()
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.75))
                        )

                    Spacer()
                        .frame(width: 4)
                }
            }
            .buttonStyle(.plain)
            .transition(.move(edge: .leading).combined(with: .opacity))
        }
    }

    private var nextUpcomingEvent: CalendarEventModel? {
        let now = Date()
        return calendarManager.todayEvents
            .filter { $0.endDate > now }
            .min(by: { abs($0.startDate.timeIntervalSince(now)) < abs($1.startDate.timeIntervalSince(now)) })
    }
}
