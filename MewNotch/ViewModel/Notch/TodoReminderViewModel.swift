//
//  TodoReminderViewModel.swift
//  MewNotch
//

import SwiftUI

class TodoReminderViewModel: ObservableObject {

    static let shared = TodoReminderViewModel()

    @Published var items: [TodoItemModel] = []
    @Published var badgeCount: Int = 0
    @Published var overdueCount: Int = 0

    let todoDefaults = TodoDefaults.shared
    let reminderDefaults = ReminderIntegrationDefaults.shared

    private var reminderCheckerTimer: Timer?

    private init() {
        loadItems()
        startReminderChecker()
        listenForReminders()
    }

    private func loadItems() {
        items = todoDefaults.sortedItems
        badgeCount = todoDefaults.pendingCount
        overdueCount = todoDefaults.overdueCount
    }

    private func startReminderChecker() {
        reminderCheckerTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.checkDueReminders()
        }
    }

    private func checkDueReminders() {
        let now = Date()

        for item in items {
            if let reminderTime = item.reminderTime, !item.isCompleted {
                if reminderTime <= now {
                    showReminderHUD(item)
                }
            }
        }

        // Also check Apple Reminders
        if reminderDefaults.appleRemindersEnabled {
            ReminderManager.shared.checkDueReminders()
        }
    }

    private func showReminderHUD(_ item: TodoItemModel) {
        if todoDefaults.hudReminderEnabled {
            NotificationCenter.default.post(
                name: NSNotification.Name("TodoReminderDue"),
                object: nil,
                userInfo: ["title": item.title, "priority": item.priority.rawValue]
            )
        }

        if todoDefaults.reminderSound {
            NSSound(named: "Glass")?.play()
        }
    }

    private func listenForReminders() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleReminderDue),
            name: NSNotification.Name("TodoReminderDue"),
            object: nil
        )

        // Sync with ReminderManager
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(syncWithReminderManager),
            name: NSNotification.Name("RemindersSynced"),
            object: nil
        )
    }

    @objc func handleReminderDue(notification: Notification) {
        guard let title = notification.userInfo?["title"] as? String else { return }
        // Badge update already handled
        loadItems()
    }

    @objc func syncWithReminderManager() {
        loadItems()
    }

    func refresh() {
        loadItems()
    }

    func getPriorityColor(_ priority: TodoItemModel.TodoPriority) -> Color {
        switch priority {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}