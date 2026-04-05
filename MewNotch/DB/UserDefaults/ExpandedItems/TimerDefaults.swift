//
//  TimerDefaults.swift
//  MewNotch
//
//  Settings storage for Timer feature
//

import SwiftUI

class TimerDefaults: ObservableObject {

    static let shared = TimerDefaults()

    private static var PREFIX: String = "Expanded_Timer_"

    private init() {}

    // MARK: - Pomodoro Settings

    @AppStorage(PREFIX + "workDuration")
    var workDuration: Double = 25 {
        didSet {
            objectWillChange.send()
        }
    }

    @AppStorage(PREFIX + "breakDuration")
    var breakDuration: Double = 5 {
        didSet {
            objectWillChange.send()
        }
    }

    // MARK: - Notifications

    @AppStorage(PREFIX + "soundEnabled")
    var soundEnabled: Bool = true {
        didSet {
            objectWillChange.send()
        }
    }

    @AppStorage(PREFIX + "notificationEnabled")
    var notificationEnabled: Bool = true {
        didSet {
            objectWillChange.send()
        }
    }

    // MARK: - Presets

    static let countdownPresets: [TimeInterval] = [
        60,      // 1 min
        300,     // 5 min
        600,     // 10 min
        900,     // 15 min
        1500,    // 25 min
        3600     // 1 hour
    ]
}
