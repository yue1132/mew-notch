//
//  MirrorSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 04/01/2026.
//

import SwiftUI

struct ExpandedMirrorSettingsView: View {

    @StateObject private var mirrorDefaults = MirrorDefaults.shared
    @StateObject private var notchDefaults = NotchDefaults.shared

    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "mirror.settings.cornerRadius".localized,
                    subtitle: "mirror.settings.cornerRadius.subtitle".localized,
                    icon: MewNotch.Assets.icCornerRadius,
                    color: MewNotch.Colors.mirror
                ) {
                    Slider(
                        value: $mirrorDefaults.cornerRadius,
                        in: 15...50,
                        step: 1
                    )
                }
            } header: {
                Text("mirror.settings.section.appearance".localized)
            }

            Section {
                SettingsRow(
                    title: "mirror.settings.autoStart".localized,
                    subtitle: "mirror.settings.autoStart.subtitle".localized,
                    icon: MewNotch.Assets.icVideo,
                    color: MewNotch.Colors.video
                ) {
                    Toggle("", isOn: $mirrorDefaults.autoStart)
                }
            } header: {
                Text("mirror.settings.section.behavior".localized)
            }
        }
        .formStyle(.grouped)
    }
}

#Preview {
    ExpandedMirrorSettingsView()
}