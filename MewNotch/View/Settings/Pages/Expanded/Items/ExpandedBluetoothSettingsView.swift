//
//  ExpandedBluetoothSettingsView.swift
//  MewNotch
//
//  Created for Bluetooth feature expansion
//

import SwiftUI

struct ExpandedBluetoothSettingsView: View {

    @StateObject private var bluetoothDefaults = BluetoothDefaults.shared
    @StateObject private var notchDefaults = NotchDefaults.shared

    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "bluetooth.refreshInterval".localized,
                    subtitle: "bluetooth.refreshInterval.subtitle".localized,
                    icon: Image(systemName: "arrow.clockwise"),
                    color: .blue
                ) {
                    HStack(spacing: 4) {
                        Text("\(Int(bluetoothDefaults.refreshInterval))" + "common.seconds".localized)
                            .font(.caption)
                            .frame(width: 35)
                        Slider(
                            value: $bluetoothDefaults.refreshInterval,
                            in: 2...30,
                            step: 1
                        )
                    }
                }
            } header: {
                Text("bluetooth.section.performance".localized)
            }

            Section {
                SettingsRow(
                    title: "bluetooth.connectionNotifications".localized,
                    subtitle: "bluetooth.connectionNotifications.subtitle".localized,
                    icon: Image(systemName: "bell"),
                    color: .purple
                ) {
                    Toggle("", isOn: $bluetoothDefaults.showConnectionNotifications)
                }
            } header: {
                Text("bluetooth.section.notifications".localized)
            }
        }
        .formStyle(.grouped)
    }
}

#Preview {
    ExpandedBluetoothSettingsView()
}
