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
                    title: "enabled",
                    subtitle: "shows_media_playing",
                    icon: MewNotch.Assets.icMedia,
                    color: MewNotch.Colors.nowPlaying
                ) {
                    Toggle("", isOn: ~$mediaDefaults.isEnabled)
                }
            } header: {
                Text("general")
            }

            Section {
                SettingsRow(
                    title: "animated",
                    subtitle: "animate_value_changes",
                    icon: MewNotch.Assets.icVideo,
                    color: MewNotch.Colors.video
                ) {
                    Toggle("", isOn: ~$mediaDefaults.animateChanges)
                }
                .hide(when: !mediaDefaults.isEnabled)
            } header: {
                Text("appearance")
            }

            Section {
                SettingsRow(
                    title: "show_title_on_change",
                    subtitle: "shows_new_media_name",
                    icon: MewNotch.Assets.icMedia,
                    color: MewNotch.Colors.nowPlaying
                ) {
                    Toggle("", isOn: ~$mediaDefaults.showTitleChange)
                }
                .hide(when: !mediaDefaults.isEnabled)

                SettingsRow(
                    title: "show_new_title_for",
                    subtitle: "\(mediaDefaults.titleChangeTimeout.formatted()) seconds",
                    icon: MewNotch.Assets.icTimer,
                    color: MewNotch.Colors.timer
                ) {
                    Slider(
                        value: $mediaDefaults.titleChangeTimeout,
                        in: 1...10,
                        step: 1.0
                    )
                }
                .hide(when: !mediaDefaults.isEnabled || !mediaDefaults.showTitleChange)
            } header: {
                Text("behavior")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("media")
    }
}

#Preview {
    HUDMediaSettingsView()
}
