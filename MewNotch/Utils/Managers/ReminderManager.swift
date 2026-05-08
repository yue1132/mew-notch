//
//  ReminderManager.swift
//  MewNotch
//

import Foundation
import EventKit

class ReminderManager: ObservableObject {

    static let shared = ReminderManager()

    @Published var reminders: [TodoItemModel] = []
    @Published var hasPermission: Bool = false

    private let eventStore = EKEventStore()
    private var syncTimer: Timer?

    private init() {
        requestPermission()
    }

    func requestPermission() {
        eventStore.requestFullAccessToReminders { granted, error in
            DispatchQueue.main.async {
                self.hasPermission = granted
                if granted {
                    self.syncReminders()
                    self.startSyncTimer()
                }
            }
        }
    }

    func syncReminders() {
        guard hasPermission, ReminderIntegrationDefaults.shared.appleRemindersEnabled else { return }

        let calendars = getSelectedLists()
        let predicate = eventStore.predicateForReminders(in: calendars)

        eventStore.fetchReminders(matching: predicate) { ekReminders in
            guard let ekReminders = ekReminders else { return }

            var models: [TodoItemModel] = []

            for reminder in ekReminders {
                if !ReminderIntegrationDefaults.shared.showCompletedFromReminders && reminder.isCompleted {
                    continue
                }

                let item = TodoItemModel(
                    title: reminder.title ?? "",
                    dueDate: reminder.dueDateComponents?.date,
                    reminderTime: nil,
                    priority: self.mapPriority(reminder.priority),
                    source: .appleReminders
                )
                models.append(item)
            }

            DispatchQueue.main.async {
                // Merge with local items
                let localItems = TodoDefaults.shared.items.filter { $0.source == .local }
                self.reminders = localItems + models

                // Sync back to defaults
                self.syncToDefaults()
            }
        }
    }

    private func getSelectedLists() -> [EKCalendar]? {
        let selected = ReminderIntegrationDefaults.shared.selectedLists
        let allCalendars = eventStore.calendars(for: .reminder)

        if selected.isEmpty {
            return allCalendars
        }

        return allCalendars.filter { selected.contains($0.calendarIdentifier) }
    }

    private func mapPriority(_ ekPriority: Int) -> TodoItemModel.TodoPriority {
        // EKReminder priority: 0=none, 1=high, 5=medium, 9=low
        switch ekPriority {
        case 1, 2, 3, 4: return .high
        case 5, 6, 7: return .medium
        case 8, 9: return .low
        default: return .medium
        }
    }

    private func startSyncTimer() {
        let interval = TimeInterval(ReminderIntegrationDefaults.shared.syncIntervalMinutes * 60)
        syncTimer?.invalidate()
        syncTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            self.syncReminders()
        }
    }

    private func syncToDefaults() {
        ReminderIntegrationDefaults.shared.lastSyncTime = Date()

        // Update TodoDefaults with merged items
        var merged = TodoDefaults.shared.items.filter { $0.source == .local }
        merged.append(contentsOf: reminders.filter { $0.source == .appleReminders })
        TodoDefaults.shared.items = merged
    }

    func getReminderLists() -> [(String, String)] {
        return eventStore.calendars(for: .reminder).map { ($0.calendarIdentifier, $0.title) }
    }

    func checkDueReminders() {
        let now = Date()

        for item in TodoDefaults.shared.items {
            if let reminderTime = item.reminderTime, !item.isCompleted {
                if reminderTime <= now && reminderTime > now.addingTimeInterval(-60) {
                    notifyDueReminder(item)
                }
            }
        }
    }

    private func notifyDueReminder(_ item: TodoItemModel) {
        NotificationCenter.default.post(
            name: NSNotification.Name("TodoReminderDue"),
            object: nil,
            userInfo: ["title": item.title, "priority": item.priority.rawValue]
        )
    }
}