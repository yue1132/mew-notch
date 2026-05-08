//
//  PomodoroSessionModel.swift
//  MewNotch
//

import Foundation

struct PomodoroSessionModel: Codable {
    var workDurationMinutes: Int
    var shortBreakMinutes: Int
    var longBreakMinutes: Int
    var sessionsBeforeLongBreak: Int
    var currentSessionType: PomodoroType
    var sessionsCompleted: Int
    var remainingSeconds: Int
    var state: PomodoroState

    enum PomodoroType: String, Codable {
        case work
        case shortBreak
        case longBreak
    }

    enum PomodoroState: String, Codable {
        case idle
        case running
        case paused
    }

    init() {
        self.workDurationMinutes = 25
        self.shortBreakMinutes = 5
        self.longBreakMinutes = 15
        self.sessionsBeforeLongBreak = 4
        self.currentSessionType = .work
        self.sessionsCompleted = 0
        self.remainingSeconds = workDurationMinutes * 60
        self.state = .idle
    }

    var totalSessionSeconds: Int {
        switch currentSessionType {
        case .work: return workDurationMinutes * 60
        case .shortBreak: return shortBreakMinutes * 60
        case .longBreak: return longBreakMinutes * 60
        }
    }

    var progress: Double {
        guard totalSessionSeconds > 0 else { return 0 }
        return Double(totalSessionSeconds - remainingSeconds) / Double(totalSessionSeconds)
    }

    var formattedTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    mutating func start() {
        state = .running
    }

    mutating func pause() {
        state = .paused
    }

    mutating func reset() {
        remainingSeconds = totalSessionSeconds
        state = .idle
    }

    mutating func tick() -> Bool {
        guard state == .running && remainingSeconds > 0 else { return false }
        remainingSeconds -= 1
        if remainingSeconds == 0 {
            return true // Session completed
        }
        return false
    }

    mutating func nextSession() {
        sessionsCompleted += 1

        if currentSessionType == .work {
            // Check if long break is needed
            if sessionsCompleted % sessionsBeforeLongBreak == 0 {
                currentSessionType = .longBreak
            } else {
                currentSessionType = .shortBreak
            }
        } else {
            currentSessionType = .work
        }

        remainingSeconds = totalSessionSeconds
        state = .idle
    }

    mutating func skipToNext() {
        if currentSessionType == .work {
            sessionsCompleted += 1
            if sessionsCompleted % sessionsBeforeLongBreak == 0 {
                currentSessionType = .longBreak
            } else {
                currentSessionType = .shortBreak
            }
        } else {
            currentSessionType = .work
        }
        remainingSeconds = totalSessionSeconds
        state = .idle
    }
}