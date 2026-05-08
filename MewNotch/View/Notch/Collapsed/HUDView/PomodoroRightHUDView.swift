//
//  PomodoroRightHUDView.swift
//  MewNotch
//

import SwiftUI

struct PomodoroRightHUDView: View {

    @ObservedObject var notchViewModel: NotchViewModel
    @ObservedObject var pomodoroManager = PomodoroManager.shared
    @ObservedObject var pomodoroDefaults = PomodoroDefaults.shared

    var body: some View {
        if pomodoroDefaults.showInCollapsed && pomodoroDefaults.enabled && pomodoroManager.session.state == .running {
            Text(pomodoroManager.session.formattedTime)
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundColor(getSessionColor())
                .fixedSize()
                .padding(.horizontal, 6)
                .padding(.vertical, notchViewModel.minimalHUDPadding)
                .frame(height: notchViewModel.notchSize.height)
                .transition(
                    .move(edge: .leading)
                    .combined(with: .opacity)
                )
                .padding(
                    .init(
                        top: 0,
                        leading: 0,
                        bottom: 0,
                        trailing: notchViewModel.extraNotchPadSize.width / 2
                    )
                )
        }
    }

    private func getSessionColor() -> Color {
        switch pomodoroManager.session.currentSessionType {
        case .work: return .red
        case .shortBreak: return .green
        case .longBreak: return .blue
        }
    }
}