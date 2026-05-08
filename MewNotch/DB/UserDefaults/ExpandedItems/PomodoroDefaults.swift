//
//  PomodoroDefaults.swift
//  MewNotch
//

import Foundation

class PomodoroDefaults: ObservableObject {

    static let shared = PomodoroDefaults()

    private static var PREFIX = "Pomodoro_"

    private init() {}

    @PrimitiveUserDefault(PREFIX + "WorkDuration", defaultValue: 25)
    var workDuration: Int {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "ShortBreakDuration", defaultValue: 5)
    var shortBreakDuration: Int {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "LongBreakDuration", defaultValue: 15)
    var longBreakDuration: Int {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "SessionsBeforeLongBreak", defaultValue: 4)
    var sessionsBeforeLongBreak: Int {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "AutoStartBreak", defaultValue: false)
    var autoStartBreak: Bool {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "ShowInCollapsed", defaultValue: true)
    var showInCollapsed: Bool {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "SoundOnComplete", defaultValue: true)
    var soundOnComplete: Bool {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "HUDOnComplete", defaultValue: true)
    var hudOnComplete: Bool {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "Enabled", defaultValue: true)
    var enabled: Bool {
        didSet { self.objectWillChange.send() }
    }

    @CodableUserDefault(PREFIX + "CurrentSession", defaultValue: PomodoroSessionModel())
    var currentSession: PomodoroSessionModel {
        didSet { self.objectWillChange.send() }
    }
}