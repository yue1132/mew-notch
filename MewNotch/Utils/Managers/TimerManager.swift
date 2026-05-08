//
//  TimerManager.swift
//  MewNotch
//

import Foundation
import SwiftUI

class TimerManager: ObservableObject {

    static let shared = TimerManager()

    @Published var activeTimers: [UUID: TimerModel] = [:]
    private var timerTicker: Timer?
    private var hapticManager: HapticsManager?

    private init() {}

    func startTimer(_ timer: TimerModel) {
        activeTimers[timer.id] = timer
        activeTimers[timer.id]?.start()
        startTicker()
        TimerDefaults.shared.activeTimerId = timer.id

        if NotchDefaults.shared.hapticFeedback {
            HapticsManager.shared.feedback(pattern: .generic)
        }
    }

    func pauseTimer(_ timerId: UUID) {
        guard activeTimers[timerId] != nil else { return }
        activeTimers[timerId]?.pause()
        saveTimerState(timerId)

        if NotchDefaults.shared.hapticFeedback {
            HapticsManager.shared.feedback(pattern: .generic)
        }
    }

    func resetTimer(_ timerId: UUID) {
        guard activeTimers[timerId] != nil else { return }
        activeTimers[timerId]?.reset()
        saveTimerState(timerId)
        TimerDefaults.shared.activeTimerId = nil

        if NotchDefaults.shared.hapticFeedback {
            HapticsManager.shared.feedback(pattern: .generic)
        }
    }

    func removeTimer(_ timerId: UUID) {
        activeTimers.removeValue(forKey: timerId)
        if TimerDefaults.shared.activeTimerId == timerId {
            TimerDefaults.shared.activeTimerId = nil
        }
        stopTickerIfEmpty()
    }

    private func startTicker() {
        guard timerTicker == nil else { return }
        timerTicker = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.tickAllTimers()
        }
    }

    private func stopTickerIfEmpty() {
        if activeTimers.isEmpty {
            timerTicker?.invalidate()
            timerTicker = nil
        }
    }

    private func tickAllTimers() {
        for (id, _) in activeTimers {
            if let completed = activeTimers[id]?.tick(), completed {
                handleTimerComplete(id)
            }
        }
        // Sync with defaults
        TimerDefaults.shared.savedTimers = activeTimers.values.map { $0 }
    }

    private func handleTimerComplete(_ timerId: UUID) {
        guard let timer = activeTimers[timerId] else { return }

        // HUD notification
        if TimerDefaults.shared.hudOnComplete {
            notifyTimerComplete(timer)
        }

        // Sound
        if TimerDefaults.shared.soundOnComplete {
            playCompletionSound()
        }

        // Haptic
        if NotchDefaults.shared.hapticFeedback {
            HapticsManager.shared.feedback(pattern: .generic)
        }

        TimerDefaults.shared.activeTimerId = nil
        stopTickerIfEmpty()
    }

    private func notifyTimerComplete(_ timer: TimerModel) {
        NotificationCenter.default.post(
            name: NSNotification.Name("TimerComplete"),
            object: nil,
            userInfo: ["timerName": timer.name, "timerId": timer.id]
        )
    }

    private func playCompletionSound() {
        NSSound(named: "Glass")?.play()
    }

    private func saveTimerState(_ timerId: UUID) {
        guard let timer = activeTimers[timerId] else { return }
        var saved = TimerDefaults.shared.savedTimers
        if let index = saved.firstIndex(where: { $0.id == timerId }) {
            saved[index] = timer
        } else {
            saved.append(timer)
        }
        TimerDefaults.shared.savedTimers = saved
    }

    func createQuickTimer(seconds: Int, name: String = "Timer") -> TimerModel {
        return TimerModel(name: name, durationSeconds: seconds)
    }
}