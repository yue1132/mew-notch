//
//  PomodoroManager.swift
//  MewNotch
//

import Foundation
import SwiftUI

class PomodoroManager: ObservableObject {

    static let shared = PomodoroManager()

    @Published var session: PomodoroSessionModel
    private var ticker: Timer?

    private init() {
        self.session = PomodoroDefaults.shared.currentSession
        syncWithDefaults()
    }

    func start() {
        session.start()
        startTicker()
        syncWithDefaults()

        if NotchDefaults.shared.hapticFeedback {
            HapticsManager.shared.feedback(pattern: .generic)
        }
    }

    func pause() {
        session.pause()
        syncWithDefaults()

        if NotchDefaults.shared.hapticFeedback {
            HapticsManager.shared.feedback(pattern: .generic)
        }
    }

    func reset() {
        session.reset()
        syncWithDefaults()

        if NotchDefaults.shared.hapticFeedback {
            HapticsManager.shared.feedback(pattern: .generic)
        }
    }

    func skipToNext() {
        session.skipToNext()
        if PomodoroDefaults.shared.autoStartBreak && session.currentSessionType != .work {
            session.start()
        }
        syncWithDefaults()

        if NotchDefaults.shared.hapticFeedback {
            HapticsManager.shared.feedback(pattern: .generic)
        }
    }

    private func startTicker() {
        stopTicker()
        ticker = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            DispatchQueue.main.async {
                self.tick()
            }
        }
        // 确保 Timer 在主 RunLoop 运行
        if let ticker = ticker {
            RunLoop.main.add(ticker, forMode: .common)
        }
    }

    private func stopTicker() {
        ticker?.invalidate()
        ticker = nil
    }

    private func tick() {
        let completed = session.tick()
        syncWithDefaults()

        if completed {
            handleSessionComplete()
        }
    }

    private func handleSessionComplete() {
        stopTicker()

        // HUD notification
        if PomodoroDefaults.shared.hudOnComplete {
            notifySessionComplete()
        }

        // Sound
        if PomodoroDefaults.shared.soundOnComplete {
            NSSound(named: "Glass")?.play()
        }

        // Haptic
        if NotchDefaults.shared.hapticFeedback {
            HapticsManager.shared.feedback(pattern: .generic)
        }

        // Auto transition
        session.nextSession()
        if PomodoroDefaults.shared.autoStartBreak {
            start()
        }
        syncWithDefaults()
    }

    private func notifySessionComplete() {
        let typeString: String
        switch session.currentSessionType {
        case .work: typeString = "Work"
        case .shortBreak: typeString = "Short Break"
        case .longBreak: typeString = "Long Break"
        }

        NotificationCenter.default.post(
            name: NSNotification.Name("PomodoroComplete"),
            object: nil,
            userInfo: ["sessionType": typeString, "sessionsCompleted": session.sessionsCompleted]
        )
    }

    private func syncWithDefaults() {
        PomodoroDefaults.shared.currentSession = session
    }

    func updateSettings() {
        session.workDurationMinutes = PomodoroDefaults.shared.workDuration
        session.shortBreakMinutes = PomodoroDefaults.shared.shortBreakDuration
        session.longBreakMinutes = PomodoroDefaults.shared.longBreakDuration
        session.sessionsBeforeLongBreak = PomodoroDefaults.shared.sessionsBeforeLongBreak
        session.remainingSeconds = session.totalSessionSeconds
        syncWithDefaults()
    }
}