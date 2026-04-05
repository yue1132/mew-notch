//
//  HUDAudioSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import SwiftUI

struct HUDAudioSettingsView: View {
    
    @StateObject private var viewModel = HUDAudioSettingsViewModel()
    
    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "common.enabled".localized,
                    subtitle: "hud.audio.showsVolumeChanges".localized,
                    icon: MewNotch.Assets.icSpeakerWave2,
                    color: MewNotch.Colors.output
                ) {
                    Toggle("", isOn: $viewModel.outputDefaults.isEnabled)
                }

                SettingsRow(
                    title: "common.style".localized,
                    icon: MewNotch.Assets.icPaintbrush,
                    color: MewNotch.Colors.style
                ) {
                    Picker("", selection: $viewModel.outputDefaults.style) {
                        ForEach(HUDStyle.allCases) { style in
                            Text(style.displayName).tag(style)
                        }
                    }
                    .labelsHidden()
                }
                .disabled(!viewModel.outputDefaults.isEnabled)

                if viewModel.outputDefaults.isEnabled {
                    HStack(alignment: .top, spacing: 16) {
                        SettingsIcon(icon: MewNotch.Assets.icChartBar, color: MewNotch.Colors.stepSize)

                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("hud.audio.stepSize".localized)
                                    .font(.title3)
                                    .fontWeight(.medium)
                                Spacer()
                                Text("\(Int(viewModel.localVolumeStep))%")
                                    .font(.body)
                                    .monospacedDigit()
                                    .bold()
                            }
                            
                            Slider(
                                value: $viewModel.localVolumeStep,
                                in: 1...10,
                                step: 1
                            )
                        }
                    }
                    .padding(.vertical, 8)
                }
            } header: {
                Text("hud.audio.output".localized)
            } footer: {
                Text("hud.audio.designDescription".localized)
            }

            Section {
                SettingsRow(
                    title: "common.enabled".localized,
                    subtitle: "hud.audio.showsVolumeChanges".localized,
                    icon: MewNotch.Assets.icMicrophone,
                    color: MewNotch.Colors.input
                ) {
                    Toggle("", isOn: $viewModel.inputDefaults.isEnabled)
                }

                SettingsRow(
                    title: "common.style".localized,
                    icon: MewNotch.Assets.icPaintbrush,
                    color: MewNotch.Colors.style
                ) {
                    Picker("", selection: $viewModel.inputDefaults.style) {
                        ForEach(HUDStyle.allCases) { style in
                            Text(style.displayName).tag(style)
                        }
                    }
                    .labelsHidden()
                }
                .disabled(!viewModel.inputDefaults.isEnabled)
            } header: {
                Text("hud.audio.input".localized)
            } footer: {
                Text("hud.audio.designDescription".localized)
            }
        }
        .formStyle(.grouped)
        .navigationTitle("settings.collapsedItems.audio".localized)
    }
}

#Preview {
    HUDAudioSettingsView()
}
