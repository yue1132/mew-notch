//
//  HUDMediaSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import SwiftUI

struct HUDMediaSettingsView: View {
    
    @StateObject var mediaDefaults = HUDMediaDefaults.shared
    
    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "common.enabled".localized,
                    subtitle: "hud.media.showsMediaPlaying".localized,
                    icon: MewNotch.Assets.icMedia,
                    color: MewNotch.Colors.nowPlaying
                ) {
                    Toggle("", isOn: $mediaDefaults.isEnabled)
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle("settings.collapsedItems.media".localized)
    }
}

#Preview {
    HUDMediaSettingsView()
}
