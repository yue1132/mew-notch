//
//  TimerViewModel.swift
//  MewNotch
//

import SwiftUI

class TimerViewModel: ObservableObject {

    static let shared = TimerViewModel()

    @Published var activeTimer: TimerModel?
    @Published var quickPresets: [Int] = []
    @Published var showTimerCompleteHUD: Bool = false

    let timerDefaults = TimerDefaults.shared
    let timerManager = TimerManager.shared

    private init() {
        loadPresets()
        loadActiveTimer()
        listenForTimerComplete()
    }

    private func loadPresets() {
        quickPresets = timerDefaults.quickTimerPresets
    }

    private func loadActiveTimer() {
        if let timerId = timerDefaults.activeTimerId {
            activeTimer = timerDefaults.savedTimers.first { $0.id == timerId }
        }
    }

    private func listenForTimerComplete() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTimerComplete),
            name: NSNotification.Name("TimerComplete"),
            object: nil
        )
    }

    @objc func handleTimerComplete(notification: Notification) {
        if timerDefaults.hudOnComplete {
            showTimerCompleteHUD = true
        }
    }

    func startQuickTimer(seconds: Int) {
        let timer = timerManager.createQuickTimer(seconds: seconds, name: formatTimerName(seconds))
        timerManager.startTimer(timer)
        activeTimer = timer
    }

    func startCustomTimer(name: String, seconds: Int) {
        let timer = TimerModel(name: name, durationSeconds: seconds)
        timerDefaults.savedTimers.append(timer)
        timerManager.startTimer(timer)
        activeTimer = timer
    }

    func pauseTimer() {
        guard let timerId = activeTimer?.id else { return }
        timerManager.pauseTimer(timerId)
        activeTimer = timerManager.activeTimers[timerId]
    }

    func resumeTimer() {
        guard let timerId = activeTimer?.id else { return }
        if let timer = timerManager.activeTimers[timerId] {
            timerManager.startTimer(timer)
        }
    }

    func resetTimer() {
        guard let timerId = activeTimer?.id else { return }
        timerManager.resetTimer(timerId)
        activeTimer = timerDefaults.savedTimers.first { $0.id == timerId }
    }

    func deleteTimer(_ timerId: UUID) {
        timerManager.removeTimer(timerId)
        timerDefaults.savedTimers.removeAll { $0.id == timerId }
        if activeTimer?.id == timerId {
            activeTimer = nil
        }
    }

    func formatTimerName(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60

        if hours > 0 {
            return "\(hours)h \(minutes)m Timer"
        } else if minutes > 0 {
            return "\(minutes)m Timer"
        } else {
            return "\(seconds)s Timer"
        }
    }

    func formatTime(_ seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = seconds % 60

        if h > 0 {
            return String(format: "%02d:%02d:%02d", h, m, s)
        }
        return String(format: "%02d:%02d", m, s)
    }

    func refresh() {
        loadActiveTimer()
    }
}