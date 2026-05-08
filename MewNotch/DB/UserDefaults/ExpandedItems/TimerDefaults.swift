//
//  TimerDefaults.swift
//  MewNotch
//

import Foundation

class TimerDefaults: ObservableObject {

    static let shared = TimerDefaults()

    private static var PREFIX = "Timer_"

    private init() {}

    @CodableUserDefault(PREFIX + "SavedTimers", defaultValue: [])
    var savedTimers: [TimerModel] {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "ShowInCollapsed", defaultValue: true)
    var showInCollapsed: Bool {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "HUDOnComplete", defaultValue: true)
    var hudOnComplete: Bool {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "SoundOnComplete", defaultValue: true)
    var soundOnComplete: Bool {
        didSet { self.objectWillChange.send() }
    }

    @CodableUserDefault(PREFIX + "QuickTimerPresets", defaultValue: [60, 300, 600, 1800])
    var quickTimerPresets: [Int] {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "ActiveTimerId", defaultValue: nil)
    var activeTimerId: UUID? {
        didSet { self.objectWillChange.send() }
    }

    var activeTimer: TimerModel? {
        guard let id = activeTimerId else { return nil }
        return savedTimers.first { $0.id == id }
    }
}