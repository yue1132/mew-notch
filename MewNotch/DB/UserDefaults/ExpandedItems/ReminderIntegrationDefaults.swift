//
//  ReminderIntegrationDefaults.swift
//  MewNotch
//

import Foundation

class ReminderIntegrationDefaults: ObservableObject {

    static let shared = ReminderIntegrationDefaults()

    private static var PREFIX = "ReminderIntegration_"

    private init() {}

    @PrimitiveUserDefault(PREFIX + "AppleRemindersEnabled", defaultValue: false)
    var appleRemindersEnabled: Bool {
        didSet { self.objectWillChange.send() }
    }

    @CodableUserDefault(PREFIX + "SelectedLists", defaultValue: [])
    var selectedLists: [String] {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "SyncIntervalMinutes", defaultValue: 5)
    var syncIntervalMinutes: Int {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "ShowCompletedFromReminders", defaultValue: false)
    var showCompletedFromReminders: Bool {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "LastSyncTime", defaultValue: nil)
    var lastSyncTime: Date? {
        didSet { self.objectWillChange.send() }
    }

    var needsSync: Bool {
        guard let lastSync = lastSyncTime else { return true }
        let elapsed = Date().timeIntervalSince(lastSync)
        return elapsed >= Double(syncIntervalMinutes * 60)
    }
}