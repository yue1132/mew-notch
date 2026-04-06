//
//  CalendarManager.swift
//  MewNotch
//
//  Manager for calendar events and reminders
//

import Foundation
import EventKit
import SwiftUI
import CoreImage

class CalendarManager: ObservableObject {

    static let shared = CalendarManager()

    private let eventStore = EKEventStore()

    @Published var todayEvents: [CalendarEventModel] = []
    @Published var upcomingReminders: [ReminderModel] = []
    @Published var isAuthorized: Bool = false
    @Published var isRefreshing: Bool = false

    private var refreshTimer: Timer?
    private let calendarDefaults = CalendarDefaults.shared

    private init() {
        checkAuthorization()
        startMonitoring()
    }

    deinit {
        stopMonitoring()
    }

    // MARK: - Authorization

    func checkAuthorization() {
        let eventStatus = EKEventStore.authorizationStatus(for: .event)
        let reminderStatus = EKEventStore.authorizationStatus(for: .reminder)

        NSLog("[Calendar] Event auth: %d, Reminder auth: %d", eventStatus.rawValue, reminderStatus.rawValue)

        let eventAuthorized = eventStatus == .fullAccess || eventStatus == .authorized
        let reminderAuthorized = reminderStatus == .fullAccess || reminderStatus == .authorized

        DispatchQueue.main.async {
            self.isAuthorized = eventAuthorized || reminderAuthorized
        }

        if eventAuthorized || reminderAuthorized {
            refreshData()
        }
    }

    var eventAuthStatus: EKAuthorizationStatus {
        EKEventStore.authorizationStatus(for: .event)
    }

    var reminderAuthStatus: EKAuthorizationStatus {
        EKEventStore.authorizationStatus(for: .reminder)
    }

    func requestAccess() {
        NSLog("[Calendar] Requesting access...")

        if #available(macOS 14.0, *) {
            eventStore.requestFullAccessToEvents { [weak self] granted, error in
                NSLog("[Calendar] Event access granted: %d, error: %@", granted, error?.localizedDescription ?? "none")
                self?.requestReminderAccess()
            }
        } else {
            eventStore.requestAccess(to: .event) { [weak self] granted, error in
                NSLog("[Calendar] Event access granted: %d, error: %@", granted, error?.localizedDescription ?? "none")
                self?.requestReminderAccess()
            }
        }
    }

    private func requestReminderAccess() {
        if #available(macOS 14.0, *) {
            eventStore.requestFullAccessToReminders { [weak self] granted, error in
                NSLog("[Calendar] Reminder access granted: %d, error: %@", granted, error?.localizedDescription ?? "none")
                DispatchQueue.main.async {
                    self?.checkAuthorization()
                }
            }
        } else {
            eventStore.requestAccess(to: .reminder) { [weak self] granted, error in
                NSLog("[Calendar] Reminder access granted: %d, error: %@", granted, error?.localizedDescription ?? "none")
                DispatchQueue.main.async {
                    self?.checkAuthorization()
                }
            }
        }
    }

    func openPrivacySettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Calendars") {
            NSWorkspace.shared.open(url)
        }
    }

    // MARK: - Monitoring

    func startMonitoring() {
        stopMonitoring()

        let interval = calendarDefaults.refreshInterval
        refreshTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.refreshData()
        }

        refreshData()
    }

    func stopMonitoring() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }

    // MARK: - Data Refresh

    func refreshData() {
        guard isAuthorized else { return }

        DispatchQueue.main.async {
            self.isRefreshing = true
        }

        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchEvents()
            if self.calendarDefaults.showReminders {
                self.fetchReminders()
            } else {
                DispatchQueue.main.async {
                    self.upcomingReminders = []
                }
            }

            DispatchQueue.main.async {
                self.isRefreshing = false
            }
        }
    }

    private func fetchEvents() {
        let calendars = eventStore.calendars(for: .event)

        let calendar = Calendar.current
        let now = Date()

        let daysToShow = calendarDefaults.daysToShow
        let startDate = calendar.startOfDay(for: now)
        guard let endDate = calendar.date(byAdding: .day, value: daysToShow, to: startDate) else { return }

        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
        let events = eventStore.events(matching: predicate)

        let sortedEvents = events
            .filter { !$0.isAllDay || calendarDefaults.showAllDay }
            .sorted { $0.startDate < $1.startDate }
            .prefix(calendarDefaults.maxEventsToShow)

        NSLog("[Calendar] Fetched %d events", sortedEvents.count)

        let eventModels = sortedEvents.map { event -> CalendarEventModel in
            var codableColor: CodableColor? = nil
            if let cgColor = event.calendar?.cgColor {
                let ciColor = CIColor(cgColor: cgColor)
                codableColor = CodableColor(
                    red: Double(ciColor.red),
                    green: Double(ciColor.green),
                    blue: Double(ciColor.blue)
                )
            }

            return CalendarEventModel(
                title: event.title,
                startDate: event.startDate,
                endDate: event.endDate,
                isAllDay: event.isAllDay,
                calendarName: event.calendar?.title,
                calendarColor: codableColor,
                eventIdentifier: event.eventIdentifier
            )
        }

        DispatchQueue.main.async {
            self.todayEvents = eventModels
        }
    }

    private func fetchReminders() {
        let calendars = eventStore.calendars(for: .reminder)

        guard !calendars.isEmpty else { return }

        let calendar = Calendar.current
        let now = Date()
        let startDate = calendar.startOfDay(for: now)
        guard let endDate = calendar.date(byAdding: .day, value: calendarDefaults.daysToShow, to: startDate) else { return }

        let predicate = eventStore.predicateForIncompleteReminders(withDueDateStarting: startDate, ending: endDate, calendars: calendars)

        eventStore.fetchReminders(matching: predicate) { reminders in
            guard let reminders = reminders else { return }

            NSLog("[Calendar] Fetched %d reminders", reminders.count)

            let reminderModels = reminders
                .sorted { ($0.dueDateComponents?.date ?? Date.distantFuture) < ($1.dueDateComponents?.date ?? Date.distantFuture) }
                .prefix(5)
                .map { reminder -> ReminderModel in
                    ReminderModel(
                        title: reminder.title,
                        dueDate: reminder.dueDateComponents?.date,
                        isCompleted: reminder.isCompleted,
                        priority: reminder.priority
                    )
                }

            DispatchQueue.main.async {
                self.upcomingReminders = reminderModels
            }
        }
    }

    // MARK: - Actions

    func openCalendarApp() {
        if let url = URL(string: "ical://") {
            NSWorkspace.shared.open(url)
        }
    }

    func openEvent(identifier: String) {
        if let event = eventStore.event(withIdentifier: identifier) {
            let url = URL(string: "ical://\(event.eventIdentifier)") ?? URL(string: "ical://")
            if let url {
                NSWorkspace.shared.open(url)
            }
        } else {
            openCalendarApp()
        }
    }

    func openRemindersApp() {
        if let url = URL(string: "x-apple-reminderkit://") {
            NSWorkspace.shared.open(url)
        }
    }
}
