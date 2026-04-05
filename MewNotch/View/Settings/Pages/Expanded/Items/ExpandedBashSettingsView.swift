//
//  ExpandedBashSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 11/02/2026.
//

import SwiftUI

struct ExpandedBashSettingsView: View {
    
    @StateObject private var bashDefaults = BashDefaults.shared
    @StateObject private var notchDefaults = NotchDefaults.shared
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Text("bash.settings.command".localized)
                        .font(.headline)
                    
                    TextEditor(text: $bashDefaults.command)
                        .font(.system(.body, design: .monospaced))
                        .frame(minHeight: 100)
                        .padding(4)
                        .background(Color(NSColor.textBackgroundColor))
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                        )
                    
                    Text("bash.settings.command.subtitle".localized)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            } header: {
                Text("bash.settings.script".localized)
            }
            
            Section {
                SettingsRow(
                    title: "bash.settings.showCommand".localized,
                    subtitle: "bash.settings.showCommand.subtitle".localized,
                    icon: Image(systemName: "text.alignleft"),
                    color: .purple
                ) {
                    Toggle("", isOn: $bashDefaults.showCommand)
                }
                
                SettingsRow(
                    title: "bash.settings.widthMultiplier".localized,
                    subtitle: "\(String(format: "%.1f", bashDefaults.widthMultiplier))x",
                    icon: Image(systemName: "text.alignleft"),
                    color: .purple
                ) {
                    Slider(
                        value: $bashDefaults.widthMultiplier,
                        in: 0.5...2.0,
                        step: 0.1
                    )
                }
                
                SettingsRow(
                    title: "bash.settings.autoRefresh".localized,
                    subtitle: "bash.settings.autoRefresh.subtitle".localized,
                    icon: Image(systemName: "arrow.clockwise.circle"),
                    color: .green
                ) {
                    Toggle("", isOn: $bashDefaults.autoRefresh)
                }
                
                SettingsRow(
                    title: "common.refreshInterval".localized,
                    subtitle: "\(Int(bashDefaults.refreshInterval))s",
                    icon: Image(systemName: "clock.arrow.circlepath"),
                    color: .green
                ) {
                    Slider(
                        value: $bashDefaults.refreshInterval,
                        in: 1.0...10.0,
                        step: 1.0
                    )
                }
                .disabled(!bashDefaults.autoRefresh)
                .opacity(bashDefaults.autoRefresh ? 1.0 : 0.6)
            } header: {
                Text("common.behavior".localized)
            }
        }
        .formStyle(.grouped)
    }
}

#Preview {
    ExpandedBashSettingsView()
}
