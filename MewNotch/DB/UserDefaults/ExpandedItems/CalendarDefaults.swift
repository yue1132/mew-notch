//
//  CalendarDefaults.swift
//  MewNotch
//

import Foundation

class CalendarDefaults: ObservableObject {

    static let shared = CalendarDefaults()

    private static var PREFIX = "Calendar_"

    private init() {}

    @PrimitiveUserDefault(PREFIX + "Enabled", defaultValue: true)
    var enabled: Bool {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "ShowTodayEvents", defaultValue: true)
    var showTodayEvents: Bool {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "ShowTomorrowEvents", defaultValue: false)
    var showTomorrowEvents: Bool {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "MaxEventsToShow", defaultValue: 5)
    var maxEventsToShow: Int {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "HUDReminderMinutes", defaultValue: 15)
    var hudReminderMinutes: Int {
        didSet { self.objectWillChange.send() }
    }

    @CodableUserDefault(PREFIX + "SelectedCalendars", defaultValue: [])
    var selectedCalendars: [String] {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "ShowOngoingEvents", defaultValue: true)
    var showOngoingEvents: Bool {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "ShowPastEvents", defaultValue: false)
    var showPastEvents: Bool {
        didSet { self.objectWillChange.send() }
    }
}