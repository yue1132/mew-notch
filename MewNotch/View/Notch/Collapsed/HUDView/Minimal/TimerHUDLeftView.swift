//
//  TimerHUDLeftView.swift
//  MewNotch
//
//  Left side of timer HUD - shows status icon
//

import SwiftUI

struct TimerHUDLeftView: View {

    @ObservedObject var notchViewModel: NotchViewModel
    @StateObject private var timerManager = TimerManager.shared

    var body: some View {
        if timerManager.isRunning || timerManager.isPaused {
            Button {
                if timerManager.isRunning {
                    timerManager.pause()
                } else {
                    timerManager.resume()
                }
            } label: {
                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: 16)
                    Circle()
                        .fill(iconColor)
                        .frame(width: 20, height: 20)
                        .overlay(
                            Image(systemName: statusIcon)
                                .font(.system(size: 11, weight: .heavy))
                                .foregroundColor(.white)
                        )
                    Spacer()
                        .frame(width: 8)
                }
            }
            .buttonStyle(.plain)
            .transition(.move(edge: .trailing).combined(with: .opacity))
        }
    }

    private var iconColor: Color {
        if timerManager.mode == .pomodoro {
            return timerManager.phase == .work ? .red : .green
        }
        return .blue
    }

    private var statusIcon: String {
        if timerManager.mode == .pomodoro {
            return timerManager.phase == .work ? "flame" : "pause"
        }
        return "clock"
    }
}