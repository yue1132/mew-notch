//
//  GeneraSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 27/02/25.
//

import SwiftUI
import LaunchAtLogin

struct GeneraSettingsView: View {

    @StateObject var appDefaults = AppDefaults.shared
    @StateObject var notchDefaults = NotchDefaults.shared
    @StateObject var languageManager = LanguageManager.shared

    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "settings.general.launchAtLogin".localized,
                    subtitle: "settings.general.launchAtLogin.subtitle".localized,
                    icon: MewNotch.Assets.icLaunchAtLogin,
                    color: MewNotch.Colors.style
                ) {
                    LaunchAtLogin.Toggle {
                        Text("")
                    }
                    .labelsHidden()
                }

                SettingsRow(
                    title: "settings.general.statusIcon".localized,
                    subtitle: "settings.general.statusIcon.subtitle".localized,
                    icon: MewNotch.Assets.icStatusIcon,
                    color: MewNotch.Colors.general
                ) {
                    Toggle("", isOn: $appDefaults.showMenuIcon)
                }
            } header: {
                Text("settings.general.section.app".localized)
            }

            Section {
                SettingsRow(
                    title: "settings.language".localized,
                    subtitle: "settings.language.subtitle".localized,
                    icon: Image(systemName: "globe"),
                    color: .blue
                ) {
                    LanguagePickerButton()
                }
            } header: {
                Text("settings.language".localized)
            }

            Section {
                SettingsRow(
                    title: "settings.general.disableSystemHUD".localized,
                    subtitle: "settings.general.disableSystemHUD.subtitle".localized,
                    icon: MewNotch.Assets.icDisableSystemHud,
                    color: MewNotch.Colors.systemHud
                ) {
                    Toggle("", isOn: $appDefaults.disableSystemHUD)
                        .onChange(of: appDefaults.disableSystemHUD) { _, newValue in
                            if newValue {
                                if !AXIsProcessTrusted() {
                                    let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
                                    AXIsProcessTrustedWithOptions(options as CFDictionary)
                                }
                                MediaKeyManager.shared.start()
                            } else {
                                MediaKeyManager.shared.stop()
                            }
                        }
                }

                if appDefaults.disableSystemHUD && !AXIsProcessTrusted() {
                    VStack(alignment: .leading, spacing: 8) {
                        Label {
                            Text("settings.general.accessibilityRequired".localized)
                        } icon: {
                            MewNotch.Assets.icWarning
                        }
                            .font(.caption)
                            .foregroundStyle(.red)

                        Button("settings.general.openSystemSettings".localized) {
                            let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
                            AXIsProcessTrustedWithOptions(options as CFDictionary)
                        }
                        .font(.caption)
                    }
                    .padding(.leading, 44) // Indent to align with text
                }
            } header: {
                Text("settings.general.section.system".localized)
            }
        }
        .formStyle(.grouped)
        .navigationTitle("settings.general".localized)
    }
}

struct LanguagePickerButton: View {
    @StateObject var languageManager = LanguageManager.shared
    @State private var showLanguageSheet = false

    var body: some View {
        Button {
            showLanguageSheet = true
        } label: {
            HStack(spacing: 4) {
                Text(languageManager.currentLanguage.displayName)
                    .font(.subheadline)
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showLanguageSheet) {
            LanguageSettingsView()
                .frame(width: 320)
        }
    }
}

#Preview {
    GeneraSettingsView()
}
