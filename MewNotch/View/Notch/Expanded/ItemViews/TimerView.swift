//
//  TimerView.swift
//  MewNotch
//
//  Timer View - Ultra Compact Layout
//

import SwiftUI

struct TimerView: View {

    @ObservedObject var notchViewModel: NotchViewModel
    @StateObject private var timerManager = TimerManager.shared
    @StateObject private var timerDefaults = TimerDefaults.shared

    @State private var selectedDuration: TimeInterval = 300
    @State private var isTimeHovered: Bool = false

    var body: some View {
        VStack(spacing: 4) {
            // Progress bar
            progressView

            // Time display with hover controls overlay
            timeView

            // Pomodoro dots (when running in pomodoro mode)
            if timerManager.isRunning || timerManager.isPaused {
                if timerManager.mode == .pomodoro {
                    pomodoroDots
                }
            }
        }
        .padding(8)
        .frame(width: notchViewModel.notchSize.width)
    }

    private var progressView: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.3))
                RoundedRectangle(cornerRadius: 2)
                    .fill(progressColor)
                    .frame(width: geo.size.width * timerManager.progress)
            }
        }
        .frame(height: 3)
    }

    private var timeView: some View {
        VStack(spacing: 1) {
            Text(timerManager.formattedTime)
                .font(.system(size: 28, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
            Text(timerManager.phaseText)
                .font(.system(size: 9))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .blur(radius: isTimeHovered ? 4.0 : 0)
        .animation(MewAnimation.fade, value: isTimeHovered)
        .overlay {
            if isTimeHovered {
                hoverControls
                    .transition(.opacity.combined(with: .scale(scale: 0.9)))
            }
        }
        .onHover { isHovered in
            isTimeHovered = isHovered
        }
    }

    private var hoverControls: some View {
        VStack(spacing: 6) {
            // Main controls row
            HStack(spacing: 12) {
                // Reset
                btn(icon: "arrow.counterclockwise", size: 10, color: .gray) {
                    timerManager.reset()
                }
                .opacity(timerManager.isRunning || timerManager.isPaused ? 1 : 0.3)

                // Play/Pause
                Button {
                    if timerManager.isRunning { timerManager.pause() }
                    else if timerManager.isPaused { timerManager.resume() }
                    else {
                        if timerManager.mode == .pomodoro {
                            timerManager.startPomodoro()
                        } else {
                            timerManager.startCountdown(duration: selectedDuration)
                        }
                    }
                } label: {
                    Image(systemName: timerManager.isRunning ? "pause.fill" : "play.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(Color.blue))
                }
                .buttonStyle(.plain)

                // Mode
                btn(
                    icon: timerManager.mode == .pomodoro ? "flame.fill" : "timer",
                    size: 10,
                    color: timerManager.mode == .pomodoro ? .red : .blue
                ) {
                    timerManager.reset()
                    timerManager.mode = timerManager.mode == .countdown ? .pomodoro : .countdown
                }
                .opacity(timerManager.isRunning || timerManager.isPaused ? 0.3 : 1)
            }

            // Duration selector (only when not running)
            if !timerManager.isRunning && !timerManager.isPaused {
                durationSelector
            }
        }
    }

    private var progressColor: Color {
        if timerManager.mode == .pomodoro {
            return timerManager.phase == .work ? .red : .green
        }
        return .blue
    }

    private var durationSelector: some View {
        HStack(spacing: 4) {
            ForEach([60, 300, 600, 1500], id: \.self) { duration in
                Button {
                    selectedDuration = duration
                } label: {
                    Text(formatDuration(duration))
                        .font(.system(size: 8, weight: .medium))
                        .foregroundColor(selectedDuration == duration ? .white : .gray)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(
                            Capsule()
                                .fill(selectedDuration == duration ? Color.blue : Color.gray.opacity(0.2))
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var pomodoroDots: some View {
        HStack(spacing: 6) {
            ForEach(0..<4, id: \.self) { i in
                Circle()
                    .fill(i < timerManager.pomodoroCount ? .red : Color.gray.opacity(0.3))
                    .frame(width: 6, height: 6)
            }
        }
    }

    private func btn(icon: String, size: CGFloat, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size))
                .foregroundColor(color)
                .frame(width: 28, height: 28)
                .background(Circle().fill(Color.gray.opacity(0.2)))
        }
        .buttonStyle(.plain)
    }

    private func formatDuration(_ s: TimeInterval) -> String {
        "\(Int(s) / 60)m"
    }
}

#Preview {
    if let screen = NSScreen.main {
        TimerView(notchViewModel: NotchViewModel(screen: screen))
    }
}
