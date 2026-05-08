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
                    title: "corner_radius",
                    subtitle: "corner_radius_subtitle",
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
                Text("mirror_appearance")
            }

            Section {
                SettingsRow(
                    title: "auto_start_mirror",
                    subtitle: "auto_start_mirror_subtitle",
                    icon: MewNotch.Assets.icVideo,
                    color: MewNotch.Colors.video
                ) {
                    Toggle("", isOn: $mirrorDefaults.autoStart)
                }
            } header: {
                Text("behavior")
            }
        }
        .formStyle(.grouped)
    }
}

#Preview {
    ExpandedMirrorSettingsView()
}
