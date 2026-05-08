//
//  PomodoroLeftHUDView.swift
//  MewNotch
//

import SwiftUI

struct PomodoroLeftHUDView: View {

    @ObservedObject var notchViewModel: NotchViewModel
    @ObservedObject var pomodoroManager = PomodoroManager.shared
    @ObservedObject var pomodoroDefaults = PomodoroDefaults.shared

    var body: some View {
        if pomodoroDefaults.showInCollapsed && pomodoroDefaults.enabled && pomodoroManager.session.state == .running {
            MinimalHUDView(
                notchViewModel: notchViewModel,
                variant: .left
            ) {
                Image(systemName: getSessionIcon())
                    .font(.system(size: 14))
                    .foregroundColor(getSessionColor())
            }
        }
    }

    private func getSessionColor() -> Color {
        switch pomodoroManager.session.currentSessionType {
        case .work: return .red
        case .shortBreak: return .green
        case .longBreak: return .blue
        }
    }

    private func getSessionIcon() -> String {
        switch pomodoroManager.session.currentSessionType {
        case .work: return "brain.head.profile"
        case .shortBreak: return "cup.and.saucer.fill"
        case .longBreak: return "figure.walk"
        }
    }
}