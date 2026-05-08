//
//  PomodoroSettingsView.swift
//  MewNotch
//

import SwiftUI

struct PomodoroSettingsView: View {

    @ObservedObject var defaults = PomodoroDefaults.shared
    @ObservedObject var pomodoroViewModel = PomodoroViewModel.shared

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Duration settings
                SettingsRow(
                    title: "work_duration",
                    icon: Image(systemName: "brain.head.profile"),
                    color: MewNotch.Colors.pomodoroWidget
                ) {
                    Picker("", selection: $defaults.workDuration) {
                        ForEach(5...60, id: \.self) { min in
                            Text("\(min) min").tag(min)
                        }
                    }
                    .frame(width: 100)
                }

                SettingsRow(
                    title: "short_break_duration",
                    icon: Image(systemName: "cup.and.saucer.fill"),
                    color: MewNotch.Colors.todoReminder
                ) {
                    Picker("", selection: $defaults.shortBreakDuration) {
                        ForEach(1...15, id: \.self) { min in
                            Text("\(min) min").tag(min)
                        }
                    }
                    .frame(width: 100)
                }

                SettingsRow(
                    title: "long_break_duration",
                    icon: Image(systemName: "figure.walk"),
                    color: MewNotch.Colors.calendarWidget
                ) {
                    Picker("", selection: $defaults.longBreakDuration) {
                        ForEach(5...30, id: \.self) { min in
                            Text("\(min) min").tag(min)
                        }
                    }
                    .frame(width: 100)
                }

                SettingsRow(
                    title: "sessions_before_long_break",
                    icon: Image(systemName: "number.circle"),
                    color: MewNotch.Colors.timer
                ) {
                    Picker("", selection: $defaults.sessionsBeforeLongBreak) {
                        ForEach(2...8, id: \.self) { count in
                            Text("\(count)").tag(count)
                        }
                    }
                    .frame(width: 60)
                }

                Divider()

                // Behavior settings
                SettingsRow(
                    title: "auto_start_break",
                    icon: Image(systemName: "play.fill"),
                    color: MewNotch.Colors.hud
                ) {
                    Toggle("", isOn: $defaults.autoStartBreak)
                        .toggleStyle(.switch)
                        .scaleEffect(0.7)
                }

                SettingsRow(
                    title: "show_in_collapsed_notch",
                    icon: MewNotch.Assets.icNotch,
                    color: MewNotch.Colors.notch
                ) {
                    Toggle("", isOn: $defaults.showInCollapsed)
                        .toggleStyle(.switch)
                        .scaleEffect(0.7)
                }

                SettingsRow(
                    title: "hud_on_complete",
                    icon: MewNotch.Assets.icHud,
                    color: MewNotch.Colors.hud
                ) {
                    Toggle("", isOn: $defaults.hudOnComplete)
                        .toggleStyle(.switch)
                        .scaleEffect(0.7)
                }

                SettingsRow(
                    title: "sound_on_complete",
                    icon: Image(systemName: "speaker.wave.2.fill"),
                    color: MewNotch.Colors.audio
                ) {
                    Toggle("", isOn: $defaults.soundOnComplete)
                        .toggleStyle(.switch)
                        .scaleEffect(0.7)
                }

                Divider()

                // Current session info
                VStack(alignment: .leading, spacing: 8) {
                    Text("current_session")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)

                    HStack {
                        Text("sessions_completed")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)

                        Text("\(defaults.currentSession.sessionsCompleted)")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.orange)
                    }

                    Button("reset_session_count") {
                        pomodoroViewModel.session.sessionsCompleted = 0
                        pomodoroViewModel.session.currentSessionType = .work
                        pomodoroViewModel.session.remainingSeconds = defaults.workDuration * 60
                        pomodoroViewModel.session.state = .idle
                        defaults.currentSession = pomodoroViewModel.session
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
        }
        .navigationTitle("pomodoro")
        .onChange(of: defaults.workDuration) { _, _ in pomodoroViewModel.updateSettings() }
        .onChange(of: defaults.shortBreakDuration) { _, _ in pomodoroViewModel.updateSettings() }
        .onChange(of: defaults.longBreakDuration) { _, _ in pomodoroViewModel.updateSettings() }
        .onChange(of: defaults.sessionsBeforeLongBreak) { _, _ in pomodoroViewModel.updateSettings() }
    }
}