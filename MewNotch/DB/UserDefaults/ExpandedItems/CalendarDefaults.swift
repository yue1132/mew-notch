//
//  CalendarDefaults.swift
//  MewNotch
//
//  Settings storage for Calendar feature
//

import SwiftUI

class CalendarDefaults: ObservableObject {

    static let shared = CalendarDefaults()

    private static var PREFIX: String = "Expanded_Calendar_"

    private init() {}

    // MARK: - Display Settings

    @AppStorage(PREFIX + "daysToShow")
    var daysToShow: Int = 3 {
        didSet {
            objectWillChange.send()
        }
    }

    @AppStorage(PREFIX + "maxEventsToShow")
    var maxEventsToShow: Int = 5 {
        didSet {
            objectWillChange.send()
        }
    }

    @AppStorage(PREFIX + "showAllDay")
    var showAllDay: Bool = true {
        didSet {
            objectWillChange.send()
        }
    }

    // MARK: - Reminders

    @AppStorage(PREFIX + "showReminders")
    var showReminders: Bool = true {
        didSet {
            objectWillChange.send()
        }
    }

    // MARK: - Refresh

    @AppStorage(PREFIX + "refreshInterval")
    var refreshInterval: Double = 300 {
        didSet {
            objectWillChange.send()
        }
    }
}
