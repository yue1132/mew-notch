//
//  TodoDefaults.swift
//  MewNotch
//

import Foundation

class TodoDefaults: ObservableObject {

    static let shared = TodoDefaults()

    private static var PREFIX = "Todo_"

    private init() {}

    @CodableUserDefault(PREFIX + "Items", defaultValue: [])
    var items: [TodoItemModel] {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "ShowBadgeCount", defaultValue: true)
    var showBadgeCount: Bool {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "ShowCompletedItems", defaultValue: false)
    var showCompletedItems: Bool {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "HUDReminderEnabled", defaultValue: true)
    var hudReminderEnabled: Bool {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "SortByPriority", defaultValue: true)
    var sortByPriority: Bool {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "ReminderSound", defaultValue: true)
    var reminderSound: Bool {
        didSet { self.objectWillChange.send() }
    }

    var pendingCount: Int {
        items.filter { !$0.isCompleted }.count
    }

    var overdueCount: Int {
        items.filter { $0.isOverdue }.count
    }

    var sortedItems: [TodoItemModel] {
        let pending = items.filter { !$0.isCompleted }
        if sortByPriority {
            return pending.sorted { $0.priority.rawValue > $1.priority.rawValue }
        }
        return pending.sorted { $0.dueDate ?? Date.distantFuture < $1.dueDate ?? Date.distantFuture }
    }
}