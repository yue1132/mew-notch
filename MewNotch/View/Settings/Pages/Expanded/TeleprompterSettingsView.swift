//
//  TeleprompterSettingsView.swift
//  MewNotch
//

import SwiftUI

struct TeleprompterSettingsView: View {

    @ObservedObject var defaults = TeleprompterDefaults.shared

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Speed control
                SettingsRow(
                    title: "scroll_speed",
                    icon: MewNotch.Assets.icTimer,
                    color: MewNotch.Colors.timer
                ) {
                    Slider(value: $defaults.scrollSpeed, in: 0.5...10, step: 0.5)
                        .frame(width: 100)

                    Text(String(format: "%.1f", defaults.scrollSpeed))
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                }

                // Font size
                SettingsRow(
                    title: "font_size",
                    icon: Image(systemName: "textformat.size"),
                    color: MewNotch.Colors.teleprompter
                ) {
                    Slider(value: $defaults.fontSize, in: 12...48, step: 2)
                        .frame(width: 100)

                    Text("\(Int(defaults.fontSize))")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                }

                // Mirror overlay
                SettingsRow(
                    title: "show_mirror_overlay",
                    icon: MewNotch.Assets.icMirror,
                    color: MewNotch.Colors.mirror
                ) {
                    Toggle("", isOn: $defaults.showMirrorOverlay)
                        .toggleStyle(.switch)
                        .scaleEffect(0.7)
                }

                if defaults.showMirrorOverlay {
                    SettingsRow(
                        title: "overlay_opacity",
                        icon: Image(systemName: "eye"),
                        color: MewNotch.Colors.glass
                    ) {
                        Slider(value: $defaults.mirrorOverlayOpacity, in: 0.1...0.5, step: 0.1)
                            .frame(width: 100)

                        Text(String(format: "%.1f", defaults.mirrorOverlayOpacity))
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                    }
                }

                // Global shortcut
                SettingsRow(
                    title: "global_shortcut",
                    icon: Image(systemName: "keyboard"),
                    color: MewNotch.Colors.hover
                ) {
                    Toggle("", isOn: $defaults.globalShortcutEnabled)
                        .toggleStyle(.switch)
                        .scaleEffect(0.7)
                }

                if defaults.globalShortcutEnabled {
                    SettingsRow(
                        title: "shortcut_key",
                        icon: Image(systemName: "command"),
                        color: MewNotch.Colors.haptic
                    ) {
                        TextField("", text: $defaults.globalShortcutKey)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 120)
                            .font(.system(size: 12))
                    }
                }

                Divider()

                // Saved scripts
                VStack(alignment: .leading, spacing: 8) {
                    Text("saved_scripts")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)

                    if defaults.scripts.isEmpty {
                        Text("no_saved_scripts")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    } else {
                        ForEach(defaults.scripts) { script in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(script.title)
                                        .font(.system(size: 12))
                                        .foregroundColor(.white)

                                    Text("\(script.content.count) chars")
                                        .font(.system(size: 10))
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                Button {
                                    defaults.currentScriptId = script.id
                                } label: {
                                    Image(systemName: defaults.currentScriptId == script.id ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(defaults.currentScriptId == script.id ? .green : .gray)
                                }
                                .buttonStyle(.plain)

                                Button {
                                    defaults.scripts.removeAll { $0.id == script.id }
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(4)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("teleprompter")
    }
}