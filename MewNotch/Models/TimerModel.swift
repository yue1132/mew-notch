//
//  TimerModel.swift
//  MewNotch
//

import Foundation

struct TimerModel: Codable, Identifiable {
    let id: UUID
    var name: String
    var durationSeconds: Int
    var remainingSeconds: Int
    var state: TimerState
    var createdAt: Date

    enum TimerState: String, Codable {
        case idle
        case running
        case paused
        case completed
    }

    init(name: String, durationSeconds: Int) {
        self.id = UUID()
        self.name = name
        self.durationSeconds = durationSeconds
        self.remainingSeconds = durationSeconds
        self.state = .idle
        self.createdAt = Date()
    }

    var progress: Double {
        guard durationSeconds > 0 else { return 0 }
        return Double(durationSeconds - remainingSeconds) / Double(durationSeconds)
    }

    var formattedTime: String {
        let hours = remainingSeconds / 3600
        let minutes = (remainingSeconds % 3600) / 60
        let seconds = remainingSeconds % 60

        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }

    mutating func start() {
        state = .running
    }

    mutating func pause() {
        state = .paused
    }

    mutating func reset() {
        remainingSeconds = durationSeconds
        state = .idle
    }

    mutating func tick() -> Bool {
        guard state == .running && remainingSeconds > 0 else { return false }
        remainingSeconds -= 1
        if remainingSeconds == 0 {
            state = .completed
            return true // Timer completed
        }
        return false
    }
}