//
//  CalendarViewModel.swift
//  MewNotch
//

import SwiftUI

class CalendarViewModel: ObservableObject {

    static let shared = CalendarViewModel()

    @Published var todayEvents: [CalendarEventModel] = []
    @Published var hasPermission: Bool = false
    @Published var showUpcomingEventHUD: Bool = false

    let calendarDefaults = CalendarDefaults.shared
    let calendarManager = CalendarManager.shared

    private init() {
        loadEvents()
        listenForUpcomingEvents()
    }

    private func loadEvents() {
        todayEvents = calendarManager.events
        hasPermission = calendarManager.hasPermission
    }

    private func listenForUpcomingEvents() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUpcomingEvent),
            name: NSNotification.Name("UpcomingCalendarEvent"),
            object: nil
        )
    }

    @objc func handleUpcomingEvent(notification: Notification) {
        showUpcomingEventHUD = true
    }

    func requestPermission() {
        calendarManager.requestPermission()
        hasPermission = calendarManager.hasPermission
    }

    func refreshEvents() {
        calendarManager.fetchEvents()
        todayEvents = calendarManager.events
    }

    func getEventColor(_ event: CalendarEventModel) -> Color {
        if event.isOngoing {
            return .blue
        }
        if event.isPast {
            return .gray.opacity(0.5)
        }
        return .orange
    }

    func getRelativeTime(_ event: CalendarEventModel) -> String {
        return event.relativeTimeString
    }

    func getNextEvent() -> CalendarEventModel? {
        return todayEvents.first { $0.isUpcoming }
    }

    func getOngoingEvent() -> CalendarEventModel? {
        return todayEvents.first { $0.isOngoing }
    }

    func formatDateHeader() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date())
    }
}