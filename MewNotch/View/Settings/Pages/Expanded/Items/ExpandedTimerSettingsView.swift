//
//  ExpandedTimerSettingsView.swift
//  MewNotch
//
//  Settings view for Timer feature
//

import SwiftUI

struct ExpandedTimerSettingsView: View {

    @StateObject private var timerDefaults = TimerDefaults.shared

    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "timer.settings.workDuration".localized,
                    subtitle: "timer.settings.workDuration.subtitle".localized,
                    icon: Image(systemName: "flame"),
                    color: .red
                ) {
                    HStack(spacing: 4) {
                        Text("\(Int(timerDefaults.workDuration))")
                            .font(.caption)
                            .frame(width: 25)
                        Slider(
                            value: $timerDefaults.workDuration,
                            in: 5...60,
                            step: 5
                        )
                        Text("common.minutes".localized)
                            .font(.caption)
                    }
                }

                SettingsRow(
                    title: "timer.settings.breakDuration".localized,
                    subtitle: "timer.settings.breakDuration.subtitle".localized,
                    icon: Image(systemName: "cup.and.saucer"),
                    color: .green
                ) {
                    HStack(spacing: 4) {
                        Text("\(Int(timerDefaults.breakDuration))")
                            .font(.caption)
                            .frame(width: 25)
                        Slider(
                            value: $timerDefaults.breakDuration,
                            in: 1...30,
                            step: 1
                        )
                        Text("common.minutes".localized)
                            .font(.caption)
                    }
                }
            } header: {
                Text("timer.settings.section.pomodoro".localized)
            }

            Section {
                SettingsRow(
                    title: "timer.settings.soundEnabled".localized,
                    subtitle: "timer.settings.soundEnabled.subtitle".localized,
                    icon: Image(systemName: "speaker.wave.2"),
                    color: .blue
                ) {
                    Toggle("", isOn: $timerDefaults.soundEnabled)
                }

                SettingsRow(
                    title: "timer.settings.notificationEnabled".localized,
                    subtitle: "timer.settings.notificationEnabled.subtitle".localized,
                    icon: Image(systemName: "bell"),
                    color: .orange
                ) {
                    Toggle("", isOn: $timerDefaults.notificationEnabled)
                }
            } header: {
                Text("timer.settings.section.notifications".localized)
            }
        }
        .formStyle(.grouped)
    }
}

#Preview {
    ExpandedTimerSettingsView()
}
