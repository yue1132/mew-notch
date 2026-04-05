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
                    title: "settings.notch.showOn".localized,
                    icon: MewNotch.Assets.icDisplay,
                    color: MewNotch.Colors.notch
                ) {
                    Picker("", selection: $notchDefaults.notchDisplayVisibility) {
                        ForEach(NotchDisplayVisibility.allCases) { item in
                            Text(item.displayName).tag(item)
                        }
                    }
                    .labelsHidden()
                }
                
                if notchDefaults.notchDisplayVisibility == .Custom {
                    VStack(spacing: 8) {
                        HStack {
                            Text("settings.notch.chooseDisplays".localized)
                                .font(.body)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Button("settings.notch.refreshList".localized) {
                                viewModel.refreshNSScreens()
                            }
                            .font(.caption)
                        }
                        
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 12) {
                                ForEach(viewModel.screens, id: \.self) { screen in
                                    ScreenSelectionButton(
                                        screenName: screen.localizedName,
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
                
                SettingsRow(
                    title: "settings.notch.lockScreen".localized,
                    subtitle: "settings.notch.lockScreen.subtitle".localized,
                    icon: MewNotch.Assets.icLock,
                    color: MewNotch.Colors.lock
                ) {
                    Toggle("", isOn: $notchDefaults.shownOnLockScreen)
                        .onChange(of: notchDefaults.shownOnLockScreen) { _, _ in
                            viewModel.refreshNotchesAndKillWindows()
                        }
                }
                
                SettingsRow(
                    title: "settings.notch.hideOnFullScreen".localized,
                    subtitle: "settings.notch.hideOnFullScreen.subtitle".localized,
                    icon: MewNotch.Assets.icDisplay,
                    color: MewNotch.Colors.notch
                ) {
                    Toggle("", isOn: $notchDefaults.hideOnFullScreen)
                        .onChange(of: notchDefaults.hideOnFullScreen) { _, _ in
                            viewModel.refreshNotches()
                        }
                }
                
                SettingsRow(
                    title: "settings.notch.resetViewOnCollapse".localized,
                    subtitle: notchDefaults.resetViewOnCollapse ? "settings.notch.resetViewOnCollapse.active".localized : "settings.notch.resetViewOnCollapse.inactive".localized,
                    icon: MewNotch.Assets.icReset,
                    color: MewNotch.Colors.notch
                ) {
                    Toggle("", isOn: $notchDefaults.resetViewOnCollapse)
                }
                
            } header: {
                Text("settings.notch.section.displays".localized)
            }

            Section {
                SettingsRow(
                    title: "settings.notch.height".localized,
                    icon: MewNotch.Assets.icHeight,
                    color: MewNotch.Colors.height
                ) {
                    Picker("", selection: $notchDefaults.heightMode) {
                        ForEach(NotchHeightMode.allCases) { item in
                            Text(item.displayName).tag(item)
                        }
                    }
                    .labelsHidden()
                }
                
                if #available(macOS 26.0, *) {
                    SettingsRow(
                        title: "settings.notch.applyGlassEffect".localized,
                        subtitle: "settings.notch.applyGlassEffect.subtitle".localized,
                        icon: MewNotch.Assets.icGlass,
                        color: MewNotch.Colors.glass
                    ) {
                        Toggle("", isOn: $notchDefaults.applyGlassEffect)
                    }
                }
            } header: {
                Text("settings.notch.section.interface".localized)
            }

            Section {
                SettingsRow(
                    title: "settings.notch.expandOnHover".localized,
                    subtitle: "settings.notch.expandOnHover.subtitle".localized,
                    icon: MewNotch.Assets.icHover,
                    color: MewNotch.Colors.hover
                ) {
                    Toggle("", isOn: Binding(
                        get: { notchDefaults.expandOnHover || notchDefaults.applyGlassEffect },
                        set: { notchDefaults.expandOnHover = $0 }
                    ))
                    .disabled(notchDefaults.applyGlassEffect)
                }
            } header: {
                Text("settings.notch.section.interaction".localized)
            }
            


        }
        .formStyle(.grouped)
        .navigationTitle("settings.notch".localized)
        .toolbarTitleDisplayMode(.inline)
        .onChange(
            of: notchDefaults.notchDisplayVisibility
        ) { _, _ in
             viewModel.refreshNotches()
        }
        .onChange(
            of: notchDefaults.shownOnDisplay
        ) { _, _ in
             viewModel.refreshNotches()
        }
        .onChange(
             of: scenePhase
        ) { _, _ in
             viewModel.refreshNSScreens()
        }
    }
}

#Preview {
    NotchSettingsView()
}

// Helper view to avoid compiler expression complexity
struct ScreenSelectionButton: View {
    let screenName: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Text(screenName)
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
