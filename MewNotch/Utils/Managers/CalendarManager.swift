//
//  CalendarManager.swift
//  MewNotch
//

import Foundation
import EventKit

class CalendarManager: ObservableObject {

    static let shared = CalendarManager()

    @Published var events: [CalendarEventModel] = []
    @Published var hasPermission: Bool = false

    private let eventStore = EKEventStore()
    private var syncTimer: Timer?

    private init() {
        requestPermission()
    }

    func requestPermission() {
        eventStore.requestFullAccessToEvents { granted, error in
            DispatchQueue.main.async {
                self.hasPermission = granted
                if granted {
                    self.fetchEvents()
                    self.startSyncTimer()
                }
            }
        }
    }

    func fetchEvents() {
        guard hasPermission, CalendarDefaults.shared.enabled else { return }

        let calendars = getSelectedCalendars()
        let predicate = buildPredicate()

        let ekEvents = eventStore.events(matching: predicate) as [EKEvent]
        let filtered = ekEvents.filter { calendars.contains($0.calendar?.calendarIdentifier ?? "") }

        var models = filtered.map { CalendarEventModel.fromEKEvent($0) }

        // Filter based on settings
        if !CalendarDefaults.shared.showPastEvents {
            models = models.filter { !$0.isPast }
        }

        // Limit count
        models = Array(models.sorted { $0.startTime < $1.startTime }.prefix(CalendarDefaults.shared.maxEventsToShow))

        events = models
    }

    private func getSelectedCalendars() -> Set<String> {
        let selected = CalendarDefaults.shared.selectedCalendars
        if selected.isEmpty {
            // Use all calendars if none selected
            return Set(eventStore.calendars(for: .event).map { $0.calendarIdentifier })
        }
        return Set(selected)
    }

    private func buildPredicate() -> NSPredicate {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        var endDate = startOfDay

        if CalendarDefaults.shared.showTomorrowEvents {
            endDate = Calendar.current.date(byAdding: .day, value: 2, to: startOfDay)!
        } else {
            endDate = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        }

        return eventStore.predicateForEvents(withStart: startOfDay, end: endDate, calendars: nil)
    }

    private func startSyncTimer() {
        let interval = TimeInterval(CalendarDefaults.shared.hudReminderMinutes * 60)
        syncTimer?.invalidate()
        syncTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.fetchEvents()
            self.checkUpcomingEvents()
        }
    }

    private func checkUpcomingEvents() {
        guard CalendarDefaults.shared.enabled else { return }

        let reminderMinutes = CalendarDefaults.shared.hudReminderMinutes
        let now = Date()
        let reminderThreshold = now.addingTimeInterval(Double(reminderMinutes * 60))

        for event in events {
            if event.startTime > now && event.startTime <= reminderThreshold {
                notifyUpcomingEvent(event)
            }
        }
    }

    private func notifyUpcomingEvent(_ event: CalendarEventModel) {
        let minutesUntil = Int(event.startTime.timeIntervalSince(Date()) / 60)

        NotificationCenter.default.post(
            name: NSNotification.Name("UpcomingCalendarEvent"),
            object: nil,
            userInfo: [
                "eventTitle": event.title,
                "minutesUntil": minutesUntil,
                "location": event.location ?? ""
            ]
        )
    }

    func getCalendarList() -> [(String, String)] {
        return eventStore.calendars(for: .event).map { ($0.calendarIdentifier, $0.title) }
    }
}