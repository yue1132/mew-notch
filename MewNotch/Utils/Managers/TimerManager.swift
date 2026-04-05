//
//  TimerManager.swift
//  MewNotch
//
//  Manager for Timer and Pomodoro functionality
//

import Foundation
import SwiftUI
import UserNotifications

enum TimerMode: String, Codable {
    case countdown
    case pomodoro
}

enum PomodoroPhase: String, Codable {
    case work
    case breakTime
}

class TimerManager: ObservableObject {

    static let shared = TimerManager()

    @Published var mode: TimerMode = .countdown
    @Published var phase: PomodoroPhase = .work

    @Published var timeRemaining: TimeInterval = 0
    @Published var totalTime: TimeInterval = 0
    @Published var isRunning: Bool = false
    @Published var isPaused: Bool = false

    @Published var pomodoroCount: Int = 0

    private var timer: Timer?
    private let defaults = TimerDefaults.shared

    private init() {
        setupNotifications()
    }

    deinit {
        stopTimer()
    }

    // MARK: - Notifications

    private func setupNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    private func sendNotification(title: String, body: String) {
        guard defaults.notificationEnabled else { return }

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = defaults.soundEnabled ? .default : .none

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - Timer Control

    func startCountdown(duration: TimeInterval) {
        mode = .countdown
        phase = .work
        totalTime = duration
        timeRemaining = duration
        isRunning = true
        isPaused = false
        startTimer()
    }

    func startPomodoro() {
        mode = .pomodoro
        phase = .work
        pomodoroCount = 0
        totalTime = defaults.workDuration * 60
        timeRemaining = totalTime
        isRunning = true
        isPaused = false
        startTimer()
    }

    func pause() {
        guard isRunning else { return }
        timer?.invalidate()
        timer = nil
        isPaused = true
        isRunning = false
    }

    func resume() {
        guard isPaused else { return }
        isPaused = false
        isRunning = true
        startTimer()
    }

    func reset() {
        stopTimer()
        timeRemaining = 0
        totalTime = 0
        isRunning = false
        isPaused = false
        pomodoroCount = 0
    }

    // MARK: - Private

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func tick() {
        timeRemaining -= 1

        if timeRemaining <= 0 {
            timerCompleted()
        }
    }

    private func timerCompleted() {
        stopTimer()

        if mode == .pomodoro {
            handlePomodoroCompletion()
        } else {
            // Countdown completed
            isRunning = false
            isPaused = false
            sendNotification(
                title: "timer.completed".localized,
                body: "timer.countdown.completed".localized
            )
            playCompletionSound()
        }
    }

    private func handlePomodoroCompletion() {
        if phase == .work {
            pomodoroCount += 1
            sendNotification(
                title: "timer.break".localized,
                body: String(format: "timer.pomodoro.completed".localized, pomodoroCount)
            )
            playCompletionSound()

            // Start break
            phase = .breakTime
            totalTime = defaults.breakDuration * 60
            timeRemaining = totalTime
            isRunning = true
            isPaused = false
            startTimer()
        } else {
            // Break completed
            sendNotification(
                title: "timer.work".localized,
                body: "timer.break.completed".localized
            )
            playCompletionSound()

            // Reset to work phase
            isRunning = false
            isPaused = false
            phase = .work
            timeRemaining = 0
            totalTime = 0
        }
    }

    private func playCompletionSound() {
        guard defaults.soundEnabled else { return }
        NSSound.beep()
    }

    // MARK: - Computed Properties

    var formattedTime: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var progress: Double {
        guard totalTime > 0 else { return 0 }
        return 1.0 - (timeRemaining / totalTime)
    }

    var phaseText: String {
        switch mode {
        case .countdown:
            return isRunning || isPaused ? "timer.countdown".localized : "timer.ready".localized
        case .pomodoro:
            return phase == .work ? "timer.work".localized : "timer.break".localized
        }
    }
}
