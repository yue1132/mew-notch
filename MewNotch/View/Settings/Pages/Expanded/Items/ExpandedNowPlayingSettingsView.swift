//
//  NowPlayingSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 04/01/2026.
//

import SwiftUI

struct ExpandedNowPlayingSettingsView: View {
    
    @StateObject private var nowPlayingDefaults = NowPlayingDefaults.shared
    @StateObject private var notchDefaults = NotchDefaults.shared
    
    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "corner_radius",
                    icon: MewNotch.Assets.icCornerRadius,
                    color: MewNotch.Colors.albumArt
                ) {
                    Slider(value: $nowPlayingDefaults.albumArtCornerRadius, in: 15...50, step: 1)
                }

                SettingsRow(
                    title: "show_artist",
                    icon: MewNotch.Assets.icArtist,
                    color: MewNotch.Colors.artist
                ) {
                    Toggle("", isOn: $nowPlayingDefaults.showArtist)
                }

                SettingsRow(
                    title: "show_album",
                    icon: MewNotch.Assets.icAlbumName,
                    color: MewNotch.Colors.albumName
                ) {
                    Toggle("", isOn: $nowPlayingDefaults.showAlbum)
                }

                SettingsRow(
                    title: "show_app_icon",
                    icon: MewNotch.Assets.icAppIcon,
                    color: MewNotch.Colors.appIcon
                ) {
                    Toggle("", isOn: $nowPlayingDefaults.showAppIcon)
                }
            } header: {
                Text("general_settings")
            }
        }
        .formStyle(.grouped)
    }
}

#Preview {
    ExpandedNowPlayingSettingsView()
}
