//
//  TimerSettingsView.swift
//  MewNotch
//

import SwiftUI

struct TimerSettingsView: View {

    @ObservedObject var defaults = TimerDefaults.shared

    @State private var newPresetMinutes: Int = 5

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Display settings
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

                // Quick presets
                VStack(alignment: .leading, spacing: 12) {
                    Text("quick_timer_presets")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)

                    HStack(spacing: 8) {
                        ForEach(defaults.quickTimerPresets, id: \.self) { seconds in
                            Text(formatTime(seconds))
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.orange.opacity(0.3))
                                .cornerRadius(6)
                        }
                    }

                    // Add preset
                    HStack {
                        TextField("Minutes", value: $newPresetMinutes, formatter: NumberFormatter())
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 60)

                        Button("add_preset") {
                            let seconds = newPresetMinutes * 60
                            if !defaults.quickTimerPresets.contains(seconds) {
                                defaults.quickTimerPresets.append(seconds)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }

                Divider()

                // Saved timers
                VStack(alignment: .leading, spacing: 12) {
                    Text("saved_timers")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)

                    if defaults.savedTimers.isEmpty {
                        Text("no_saved_timers")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    } else {
                        ForEach(defaults.savedTimers) { timer in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(timer.name)
                                        .font(.system(size: 12))
                                        .foregroundColor(.white)

                                    Text(formatTime(timer.durationSeconds))
                                        .font(.system(size: 10))
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                Button {
                                    defaults.savedTimers.removeAll { $0.id == timer.id }
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(4)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("timer")
    }

    private func formatTime(_ seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = seconds % 60

        if h > 0 {
            return String(format: "%dh %dm", h, m)
        } else if m > 0 {
            return String(format: "%dm", m)
        }
        return String(format: "%ds", s)
    }
}