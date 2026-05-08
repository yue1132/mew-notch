//
//  TimerView.swift
//  MewNotch
//

import SwiftUI

struct TimerView: View {

    @ObservedObject var viewModel = TimerViewModel.shared
    @ObservedObject var notchViewModel: NotchViewModel

    @State private var showCreateTimer: Bool = false
    @State private var newTimerMinutes: Int = 5
    @State private var newTimerSeconds: Int = 0
    @State private var newTimerName: String = ""

    var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                Image(systemName: "timer")
                    .foregroundColor(MewNotch.Colors.timerWidget.color)

                Text("timer")
                    .font(.system(size: 14, weight: .semibold))

                Spacer()

                Button {
                    showCreateTimer.toggle()
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.green)
                }
                .buttonStyle(.plain)
            }

            // Active timer display
            if let timer = viewModel.activeTimer {
                VStack(spacing: 16) {
                    // Timer display
                    Text(timer.formattedTime)
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                        .foregroundColor(timer.state == .completed ? .green : .white)

                    // Timer name
                    Text(timer.name)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)

                    // Progress bar
                    ProgressView(value: timer.progress)
                        .tint(.orange)
                        .frame(width: 150)

                    // Controls
                    HStack(spacing: 24) {
                        if timer.state == .running {
                            Button {
                                viewModel.pauseTimer()
                            } label: {
                                Image(systemName: "pause.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.orange)
                            }
                            .buttonStyle(.plain)
                        } else if timer.state == .paused {
                            Button {
                                viewModel.resumeTimer()
                            } label: {
                                Image(systemName: "play.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.green)
                            }
                            .buttonStyle(.plain)
                        }

                        Button {
                            viewModel.resetTimer()
                        } label: {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 20))
                                .foregroundColor(.gray)
                        }
                        .buttonStyle(.plain)

                        Button {
                            viewModel.deleteTimer(timer.id)
                        } label: {
                            Image(systemName: "trash")
                                .font(.system(size: 20))
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
            } else {
                // Quick presets
                VStack(spacing: 12) {
                    Text("quick_start")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)

                    HStack(spacing: 8) {
                        ForEach(viewModel.quickPresets, id: \.self) { seconds in
                            Button {
                                viewModel.startQuickTimer(seconds: seconds)
                            } label: {
                                Text(viewModel.formatTime(seconds))
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.orange.opacity(0.3))
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }

            // Create new timer
            if showCreateTimer {
                VStack(spacing: 12) {
                    HStack(spacing: 4) {
                        TextField("name", text: $newTimerName)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 100)

                        TextField("Min", value: $newTimerMinutes, formatter: NumberFormatter())
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 50)

                        Text(":")
                            .foregroundColor(.gray)

                        TextField("Sec", value: $newTimerSeconds, formatter: NumberFormatter())
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 50)
                    }

                    HStack {
                        Button("cancel") {
                            showCreateTimer = false
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(.gray)

                        Button("start") {
                            let totalSeconds = newTimerMinutes * 60 + newTimerSeconds
                            viewModel.startCustomTimer(
                                name: newTimerName.isEmpty ? "Custom Timer" : newTimerName,
                                seconds: totalSeconds
                            )
                            showCreateTimer = false
                            newTimerName = ""
                            newTimerMinutes = 5
                            newTimerSeconds = 0
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(.green)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(8)
            }

            // Saved timers
            if !viewModel.timerDefaults.savedTimers.isEmpty && viewModel.activeTimer == nil {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.timerDefaults.savedTimers) { timer in
                            HStack {
                                Text(timer.name)
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)

                                Spacer()

                                Text(viewModel.formatTime(timer.durationSeconds))
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)

                                Button {
                                    viewModel.startCustomTimer(name: timer.name, seconds: timer.durationSeconds)
                                } label: {
                                    Image(systemName: "play.fill")
                                        .foregroundColor(.green)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(6)
                        }
                    }
                }
                .frame(height: 80)
            }
        }
        .padding(12)
    }
}