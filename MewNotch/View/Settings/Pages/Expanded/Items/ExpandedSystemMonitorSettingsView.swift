//
//  ExpandedSystemMonitorSettingsView.swift
//  MewNotch
//
//  Settings view for System Monitor feature
//

import SwiftUI

struct ExpandedSystemMonitorSettingsView: View {

    @StateObject private var defaults = SystemMonitorDefaults.shared

    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "systemMonitor.settings.showCpu".localized,
                    subtitle: "systemMonitor.settings.showCpu.subtitle".localized,
                    icon: Image(systemName: "cpu"),
                    color: .blue
                ) {
                    Toggle("", isOn: $defaults.showCpu)
                }

                SettingsRow(
                    title: "systemMonitor.settings.showMemory".localized,
                    subtitle: "systemMonitor.settings.showMemory.subtitle".localized,
                    icon: Image(systemName: "memorychip"),
                    color: .purple
                ) {
                    Toggle("", isOn: $defaults.showMemory)
                }

                SettingsRow(
                    title: "systemMonitor.settings.showNetwork".localized,
                    subtitle: "systemMonitor.settings.showNetwork.subtitle".localized,
                    icon: Image(systemName: "wifi"),
                    color: .green
                ) {
                    Toggle("", isOn: $defaults.showNetwork)
                }
            } header: {
                Text("systemMonitor.settings.section.display".localized)
            }

            Section {
                SettingsRow(
                    title: "common.refreshInterval".localized,
                    subtitle: "systemMonitor.settings.refreshInterval.subtitle".localized,
                    icon: Image(systemName: "arrow.clockwise"),
                    color: .orange
                ) {
                    HStack(spacing: 4) {
                        Text("\(Int(defaults.refreshInterval))")
                            .font(.caption)
                            .frame(width: 25)
                        Slider(
                            value: $defaults.refreshInterval,
                            in: 0.5...5,
                            step: 0.5
                        )
                        Text("common.seconds".localized)
                            .font(.caption)
                    }
                }
            } header: {
                Text("common.behavior".localized)
            }
        }
        .formStyle(.grouped)
    }
}

#Preview {
    ExpandedSystemMonitorSettingsView()
}
