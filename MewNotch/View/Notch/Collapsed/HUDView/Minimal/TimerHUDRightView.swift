//
//  TimerHUDRightView.swift
//  MewNotch
//
//  Right side of timer HUD - shows countdown time
//

import SwiftUI

struct TimerHUDRightView: View {

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
                        .frame(width: 8)
                    Text(timerManager.formattedTime)
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .monospacedDigit()
                        .fixedSize()
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.75))
                        )
                    Spacer()
                        .frame(width: 4)
                }
            }
            .buttonStyle(.plain)
            .transition(.move(edge: .leading).combined(with: .opacity))
        }
    }
}