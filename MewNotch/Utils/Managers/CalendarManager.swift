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
        let calendarStatus = EKEventStore.authorizationStatus(for: .event)

        isAuthorized = calendarStatus == .fullAccess || calendarStatus == .authorized

        if isAuthorized {
            refreshData()
        }
    }

    func requestAccess() async -> Bool {
        // Request calendar access
        let calendarGranted = await withCheckedContinuation { continuation in
            if #available(macOS 14.0, *) {
                eventStore.requestFullAccessToEvents { granted, _ in
                    continuation.resume(returning: granted)
                }
            } else {
                eventStore.requestAccess(to: .event) { granted, _ in
                    continuation.resume(returning: granted)
                }
            }
        }

        await MainActor.run {
            self.isAuthorized = calendarGranted
        }

        if calendarGranted {
            refreshData()
        }

        return calendarGranted
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

        // Determine date range based on settings
        let daysToShow = calendarDefaults.daysToShow
        let startDate = calendar.startOfDay(for: now)
        guard let endDate = calendar.date(byAdding: .day, value: daysToShow, to: startDate) else { return }

        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
        let events = eventStore.events(matching: predicate)

        // Sort by start date and filter
        let sortedEvents = events
            .filter { !$0.isAllDay || calendarDefaults.showAllDay }
            .sorted { $0.startDate < $1.startDate }
            .prefix(calendarDefaults.maxEventsToShow)

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
                calendarColor: codableColor
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

    func openRemindersApp() {
        if let url = URL(string: "x-apple-reminderkit://") {
            NSWorkspace.shared.open(url)
        }
    }
}
