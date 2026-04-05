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
                    title: "nowPlaying.settings.cornerRadius".localized,
                    icon: MewNotch.Assets.icCornerRadius,
                    color: MewNotch.Colors.albumArt
                ) {
                    Slider(value: $nowPlayingDefaults.albumArtCornerRadius, in: 15...50, step: 1)
                }

                SettingsRow(
                    title: "nowPlaying.settings.showArtist".localized,
                    icon: MewNotch.Assets.icArtist,
                    color: MewNotch.Colors.artist
                ) {
                    Toggle("", isOn: $nowPlayingDefaults.showArtist)
                }

                SettingsRow(
                    title: "nowPlaying.settings.showAlbum".localized,
                    icon: MewNotch.Assets.icAlbumName,
                    color: MewNotch.Colors.albumName
                ) {
                    Toggle("", isOn: $nowPlayingDefaults.showAlbum)
                }

                SettingsRow(
                    title: "nowPlaying.settings.showAppIcon".localized,
                    icon: MewNotch.Assets.icAppIcon,
                    color: MewNotch.Colors.appIcon
                ) {
                    Toggle("", isOn: $nowPlayingDefaults.showAppIcon)
                }
            } header: {
                Text("common.generalSettings".localized)
            }
        }
        .formStyle(.grouped)
    }
}

#Preview {
    ExpandedNowPlayingSettingsView()
}
