//
//  TodoItemModel.swift
//  MewNotch
//

import Foundation

struct TodoItemModel: Codable, Identifiable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var dueDate: Date?
    var reminderTime: Date?
    var priority: TodoPriority
    var source: TodoSource
    var externalId: String?

    enum TodoPriority: Int, Codable {
        case low = 0
        case medium = 1
        case high = 2
    }

    enum TodoSource: String, Codable {
        case local
        case appleReminders
    }

    init(
        title: String,
        dueDate: Date? = nil,
        reminderTime: Date? = nil,
        priority: TodoPriority = .medium,
        source: TodoSource = .local
    ) {
        self.id = UUID()
        self.title = title
        self.isCompleted = false
        self.dueDate = dueDate
        self.reminderTime = reminderTime
        self.priority = priority
        self.source = source
        self.externalId = nil
    }

    var isOverdue: Bool {
        guard let dueDate = dueDate, !isCompleted else { return false }
        return dueDate < Date()
    }

    var priorityColorName: String {
        switch priority {
        case .low: return "green"
        case .medium: return "orange"
        case .high: return "red"
        }
    }
}