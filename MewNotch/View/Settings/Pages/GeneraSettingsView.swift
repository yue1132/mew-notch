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
    @StateObject var languageDefaults = LanguageDefaults.shared
    @StateObject var languageManager = LanguageManager.shared

    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "launch_at_login",
                    subtitle: "launch_at_login_subtitle",
                    icon: MewNotch.Assets.icLaunchAtLogin,
                    color: MewNotch.Colors.style
                ) {
                    LaunchAtLogin.Toggle {
                        Text("")
                    }
                    .labelsHidden()
                }

                SettingsRow(
                    title: "status_icon",
                    subtitle: "status_icon_subtitle",
                    icon: MewNotch.Assets.icStatusIcon,
                    color: MewNotch.Colors.general
                ) {
                    Toggle("", isOn: $appDefaults.showMenuIcon)
                }

                SettingsRow(
                    title: "language",
                    subtitle: "language_subtitle",
                    icon: MewNotch.Assets.icLanguage,
                    color: MewNotch.Colors.language
                ) {
                    Picker("", selection: $languageDefaults.languageCode) {
                        Text("english").tag("en")
                        Text("chinese").tag("zh-CN")
                    }
                    .labelsHidden()
                    .onChange(of: languageDefaults.languageCode) { _, newValue in
                        languageManager.updateLocale(languageCode: newValue)
                    }
                }
            } header: {
                Text(LocalizedStringResource("app"))
            }

            Section {
                SettingsRow(
                    title: "disable_system_hud",
                    subtitle: "disable_system_hud_subtitle",
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
                            Text("accessibility_required")
                        } icon: {
                            MewNotch.Assets.icWarning
                        }
                            .font(.caption)
                            .foregroundStyle(.red)

                        Button("open_system_settings") {
                            let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
                            AXIsProcessTrustedWithOptions(options as CFDictionary)
                        }
                        .font(.caption)
                    }
                    .padding(.leading, 44) // Indent to align with text
                }
            } header: {
                Text(LocalizedStringResource("system"))
            }
        }
        .formStyle(.grouped)
        .navigationTitle("general")
    }
}

#Preview {
    GeneraSettingsView()
}
