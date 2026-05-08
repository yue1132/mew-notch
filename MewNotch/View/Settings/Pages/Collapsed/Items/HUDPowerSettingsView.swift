//
//  HUDPowerSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import SwiftUI

struct HUDPowerSettingsView: View {
    
    @StateObject var powerDefaults = HUDPowerDefaults.shared
    
    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "enabled",
                    subtitle: "shows_power_state",
                    icon: MewNotch.Assets.icPower,
                    color: MewNotch.Colors.power
                ) {
                    Toggle("", isOn: ~$powerDefaults.isEnabled)
                }
            } header: {
                Text("general")
            }

            Section {
                SettingsRow(
                    title: "show_time_remaining",
                    subtitle: "shows_time_remaining",
                    icon: MewNotch.Assets.icTimer,
                    color: MewNotch.Colors.timer
                ) {
                    Toggle("", isOn: $powerDefaults.showTimeRemaining)
                }
                .hide(when: !powerDefaults.isEnabled)
            } header: {
                Text("details")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("power")
    }
}

#Preview {
    HUDPowerSettingsView()
}
