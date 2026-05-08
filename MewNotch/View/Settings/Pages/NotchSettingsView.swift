//
//  NotchSettingsView.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import SwiftUI


struct NotchSettingsView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject private var viewModel = NotchSettingsViewModel()
    
    @StateObject var notchDefaults = NotchDefaults.shared
    @StateObject var mirrorDefaults = MirrorDefaults.shared
    
    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "show_notch_on",
                    icon: MewNotch.Assets.icDisplay,
                    color: MewNotch.Colors.notch
                ) {
                    Picker("", selection: ~$notchDefaults.notchDisplayVisibility) {
                        ForEach(NotchDisplayVisibility.allCases) { item in
                            Text(item.displayName).tag(item)
                        }
                    }
                    .labelsHidden()
                }

                if notchDefaults.notchDisplayVisibility == .Custom {
                    customDisplaySelector
                }

                SettingsRow(
                    title: "show_on_lock_screen",
                    subtitle: "show_on_lock_screen_subtitle",
                    icon: MewNotch.Assets.icLock,
                    color: MewNotch.Colors.lock
                ) {
                    Toggle("", isOn: $notchDefaults.shownOnLockScreen)
                        .onChange(of: notchDefaults.shownOnLockScreen) { _, _ in
                            viewModel.refreshNotchesAndKillWindows()
                        }
                }

                SettingsRow(
                    title: "hide_on_full_screen",
                    subtitle: "hide_on_full_screen_subtitle",
                    icon: MewNotch.Assets.icDisplay,
                    color: MewNotch.Colors.notch
                ) {
                    Toggle("", isOn: $notchDefaults.hideOnFullScreen)
                        .onChange(of: notchDefaults.hideOnFullScreen) { _, _ in
                            viewModel.refreshNotches()
                        }
                }

                SettingsRow(
                    title: "reset_view_on_collapse",
                    subtitle: notchDefaults.resetViewOnCollapse ? "reset_on_collapse_true" : "reset_on_collapse_false",
                    icon: MewNotch.Assets.icReset,
                    color: MewNotch.Colors.notch
                ) {
                    Toggle("", isOn: $notchDefaults.resetViewOnCollapse)
                }

            } header: {
                Text(LocalizedStringResource("displays"))
            }
            
            Section {
                SettingsRow(
                    title: "height",
                    icon: MewNotch.Assets.icHeight,
                    color: MewNotch.Colors.height
                ) {
                    Picker("", selection: $notchDefaults.heightMode) {
                        ForEach([NotchHeightMode.Match_Notch, NotchHeightMode.Match_Menu_Bar]) { item in
                            Text(item.displayName).tag(item)
                        }
                    }
                    .labelsHidden()
                }

                if #available(macOS 26.0, *) {
                    SettingsRow(
                        title: "apply_glass_effect",
                        subtitle: "glass_effect_subtitle",
                        icon: MewNotch.Assets.icGlass,
                        color: MewNotch.Colors.glass
                    ) {
                        Toggle("", isOn: ~$notchDefaults.applyGlassEffect)
                    }
                }
            } header: {
                Text(LocalizedStringResource("interface"))
            }
            
            Section {
                SettingsRow(
                    title: "expand_on_hover",
                    subtitle: "expand_on_hover_subtitle",
                    icon: MewNotch.Assets.icHover,
                    color: MewNotch.Colors.hover
                ) {
                    Toggle("", isOn: Binding(
                        get: { notchDefaults.expandOnHover || notchDefaults.applyGlassEffect },
                        set: { newValue in
                            withAnimation {
                                notchDefaults.expandOnHover = newValue
                            }
                        }
                    ))
                }
                .disabled(notchDefaults.applyGlassEffect)

                SettingsRow(
                    title: "hover_delay",
                    subtitle: "\(notchDefaults.expandOnHoverDelay.formatted()) seconds.\n",
                    icon: MewNotch.Assets.icTimer,
                    color: MewNotch.Colors.timer
                ) {
                    Slider(
                        value: $notchDefaults.expandOnHoverDelay,
                        in: 0.1...2.0,
                        step: 0.1
                    )
                }
                .hide(when: !notchDefaults.expandOnHover && !notchDefaults.applyGlassEffect)

                SettingsRow(
                    title: "haptic_feedback",
                    subtitle: "haptic_feedback_subtitle",
                    icon: MewNotch.Assets.icHaptic,
                    color: MewNotch.Colors.haptic
                ) {
                    Toggle("", isOn: $notchDefaults.hapticFeedback)
                }
            } header: {
                Text(LocalizedStringResource("interaction"))
            }
        }
        .formStyle(.grouped)
        .navigationTitle("notch")
        .toolbarTitleDisplayMode(.inline)
        .onChange(
            of: notchDefaults.shownOnDisplay
        ) { _, _ in
             viewModel.refreshNotches()
        }
    }

    @ViewBuilder
    private var customDisplaySelector: some View {
        VStack(spacing: 8) {
            Text("choose_display")
                .font(.body)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            ScrollView(.horizontal) {
                LazyHStack(spacing: 12) {
                    ForEach(viewModel.screens, id: \.self) { screen in
                        DisplaySelectionButton(
                            screen: screen,
                            isSelected: notchDefaults.shownOnDisplay[screen.localizedName] == true,
                            onTap: {
                                let old = notchDefaults.shownOnDisplay[screen.localizedName] ?? false
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    notchDefaults.shownOnDisplay[screen.localizedName] = !old
                                }
                            }
                        )
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding(.vertical, 4)
    }
}

struct DisplaySelectionButton: View {
    let screen: NSScreen
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Text(screen.localizedName)
            .font(.subheadline)
            .frame(minHeight: 50)
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.15) : Color.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                    .padding(1)
            )
            .onTapGesture(perform: onTap)
    }
}

#Preview {
    NotchSettingsView()
}
