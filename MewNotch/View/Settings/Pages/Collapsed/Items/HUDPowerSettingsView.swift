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
                    title: "common.enabled".localized,
                    subtitle: "hud.power.showsPowerState".localized,
                    icon: MewNotch.Assets.icPower,
                    color: MewNotch.Colors.power
                ) {
                    Toggle("", isOn: $powerDefaults.isEnabled)
                }

                SettingsRow(
                    title: "hud.power.showTimeRemaining".localized,
                    subtitle: "hud.power.showTimeRemaining.subtitle".localized,
                    icon: MewNotch.Assets.icTimer,
                    color: MewNotch.Colors.timer
                ) {
                    Toggle("", isOn: $powerDefaults.showTimeRemaining)
                }
                .disabled(!powerDefaults.isEnabled)
            }
        }
        .formStyle(.grouped)
        .navigationTitle("settings.collapsedItems.power".localized)
    }
}

#Preview {
    HUDPowerSettingsView()
}
