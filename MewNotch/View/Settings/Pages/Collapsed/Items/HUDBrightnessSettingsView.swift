//
//  HUDBrightnessSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import SwiftUI

struct HUDBrightnessSettingsView: View {
    
    @StateObject private var viewModel = HUDBrightnessSettingsViewModel()
    
    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "common.enabled".localized,
                    subtitle: "hud.brightness.showsBrightnessChanges".localized,
                    icon: MewNotch.Assets.icBrightnessFill,
                    color: MewNotch.Colors.brightness
                ) {
                    Toggle("", isOn: $viewModel.defaults.isEnabled)
                }

                SettingsRow(
                    title: "common.style".localized,
                    icon: MewNotch.Assets.icPaintbrush,
                    color: MewNotch.Colors.style
                ) {
                    Picker("", selection: $viewModel.defaults.style) {
                        ForEach(HUDStyle.allCases) { style in
                            Text(style.displayName).tag(style)
                        }
                    }
                    .labelsHidden()
                }
                .disabled(!viewModel.defaults.isEnabled)

                SettingsRow(
                    title: "hud.brightness.showAutoBrightness".localized,
                    icon: MewNotch.Assets.icBoltBadgeAutomatic,
                    color: MewNotch.Colors.autoBrightness
                ) {
                    Toggle("", isOn: $viewModel.defaults.showAutoBrightnessChanges)
                }
                
                if viewModel.defaults.isEnabled {
                    HStack(alignment: .top, spacing: 16) {
                        SettingsIcon(icon: MewNotch.Assets.icChartBar, color: MewNotch.Colors.stepSize)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("hud.audio.stepSize".localized)
                                    .font(.title3)
                                    .fontWeight(.medium)
                                Spacer()
                                Text("\(Int(viewModel.localStep * 100))%")
                                    .font(.body)
                                    .monospacedDigit()
                                    .bold()
                            }
                            
                            Slider(
                                value: $viewModel.localStep,
                                in: 0.01...0.10,
                                step: 0.01
                            )
                        }
                    }
                    .padding(.vertical, 8)
                }
            } footer: {
               Text("hud.audio.designDescription".localized)
            }
        }
        .formStyle(.grouped)
        .navigationTitle("settings.collapsedItems.brightness".localized)
    }
}

#Preview {
    HUDBrightnessSettingsView()
}
