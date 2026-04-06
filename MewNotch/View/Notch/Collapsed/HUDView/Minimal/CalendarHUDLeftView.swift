//
//  CalendarHUDLeftView.swift
//  MewNotch
//
//  Left side calendar HUD - shows countdown to next event
//

import SwiftUI

struct CalendarHUDLeftView: View {

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
                        .frame(width: 16)

                    HStack(spacing: 3) {
                        Circle()
                            .fill(nextEvent.calendarColor?.color ?? Color.blue)
                            .frame(width: 6, height: 6)

                        Text(countdownText(for: nextEvent))
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                            .monospacedDigit()
                            .fixedSize()
                            .fixedSize()
                    }

                    Spacer()
                        .frame(width: 8)
                }
            }
            .buttonStyle(.plain)
            .transition(.move(edge: .trailing).combined(with: .opacity))
        }
    }

    private var nextUpcomingEvent: CalendarEventModel? {
        let now = Date()
        return calendarManager.todayEvents
            .filter { $0.endDate > now }
            .min(by: { abs($0.startDate.timeIntervalSince(now)) < abs($1.startDate.timeIntervalSince(now)) })
    }

    private func countdownText(for event: CalendarEventModel) -> String {
        if event.isNow { return "●" }

        let interval = event.startDate.timeIntervalSince(Date())
        if interval <= 0 { return "" }

        let minutes = Int(interval / 60)
        if minutes < 60 { return "\(minutes)m" }

        let hours = minutes / 60
        let rem = minutes % 60
        return rem == 0 ? "\(hours)h" : "\(hours)h\(rem)m"
    }
}
