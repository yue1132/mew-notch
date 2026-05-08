//
//  PomodoroViewModel.swift
//  MewNotch
//

import SwiftUI

class PomodoroViewModel: ObservableObject {

    static let shared = PomodoroViewModel()

    @Published var session: PomodoroSessionModel
    @Published var showSessionCompleteHUD: Bool = false

    let pomodoroDefaults = PomodoroDefaults.shared
    let pomodoroManager = PomodoroManager.shared

    private var refreshTimer: Timer?

    private init() {
        session = PomodoroDefaults.shared.currentSession
        listenForSessionComplete()
        startAutoRefresh()
    }

    private func listenForSessionComplete() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSessionComplete),
            name: NSNotification.Name("PomodoroComplete"),
            object: nil
        )
    }

    @objc func handleSessionComplete(notification: Notification) {
        showSessionCompleteHUD = true
        session = pomodoroManager.session
    }

    // 每秒自动刷新 session，确保界面实时显示
    private func startAutoRefresh() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            DispatchQueue.main.async {
                self.refresh()
            }
        }
        if let timer = refreshTimer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }

    func start() {
        pomodoroManager.start()
        session = pomodoroManager.session
    }

    func pause() {
        pomodoroManager.pause()
        session = pomodoroManager.session
    }

    func reset() {
        pomodoroManager.reset()
        session = pomodoroManager.session
    }

    func skip() {
        pomodoroManager.skipToNext()
        session = pomodoroManager.session
    }

    func updateSettings() {
        pomodoroManager.updateSettings()
        session = pomodoroManager.session
    }

    func getSessionColor() -> Color {
        switch session.currentSessionType {
        case .work: return .red
        case .shortBreak: return .green
        case .longBreak: return .blue
        }
    }

    func getSessionIcon() -> String {
        switch session.currentSessionType {
        case .work: return "brain.head.profile"
        case .shortBreak: return "cup.and.saucer.fill"
        case .longBreak: return "figure.walk"
        }
    }

    func refresh() {
        session = pomodoroManager.session
    }
}