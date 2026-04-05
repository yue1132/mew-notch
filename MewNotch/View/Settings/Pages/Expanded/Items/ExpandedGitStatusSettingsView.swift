//
//  ExpandedGitStatusSettingsView.swift
//  MewNotch
//
//  Updated settings for intelligent repository discovery
//

import SwiftUI

struct ExpandedGitStatusSettingsView: View {

    @StateObject private var gitDefaults = GitStatusDefaults.shared
    @StateObject private var notchDefaults = NotchDefaults.shared
    @State private var newScanPath: String = ""
    @State private var scanPathsList: [String] = []

    var body: some View {
        Form {
            Section {
                // Scan paths
                VStack(alignment: .leading, spacing: 8) {
                    Text("git.settings.scanPaths".localized)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ForEach(scanPathsList, id: \.self) { path in
                        HStack {
                            Text(path)
                                .font(.subheadline)
                            Spacer()
                            Button {
                                scanPathsList.removeAll { $0 == path }
                                gitDefaults.scanPaths = scanPathsList
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red.opacity(0.7))
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    HStack {
                        TextField("git.settings.scanPathPlaceholder".localized, text: $newScanPath)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 150)

                        Button("git.settings.addPath".localized) {
                            if !newScanPath.isEmpty && !scanPathsList.contains(newScanPath) {
                                scanPathsList.append(newScanPath)
                                gitDefaults.scanPaths = scanPathsList
                                newScanPath = ""
                            }
                        }
                        .disabled(newScanPath.isEmpty)
                    }
                }

                SettingsRow(
                    title: "git.settings.scanDepth".localized,
                    subtitle: "git.settings.scanDepth.subtitle".localized,
                    icon: Image(systemName: "layers"),
                    color: .purple
                ) {
                    Picker("", selection: $gitDefaults.scanDepth) {
                        Text("1").tag(1)
                        Text("2").tag(2)
                        Text("3").tag(3)
                    }
                    .frame(width: 60)
                }

                SettingsRow(
                    title: "git.settings.maxRepos".localized,
                    subtitle: "git.settings.maxRepos.subtitle".localized,
                    icon: Image(systemName: "list.bullet"),
                    color: .blue
                ) {
                    Picker("", selection: $gitDefaults.maxRepositoriesToShow) {
                        Text("2").tag(2)
                        Text("3").tag(3)
                        Text("4").tag(4)
                        Text("5").tag(5)
                    }
                    .frame(width: 60)
                }

                SettingsRow(
                    title: "git.settings.activityThreshold".localized,
                    subtitle: "git.settings.activityThreshold.subtitle".localized,
                    icon: Image(systemName: "clock"),
                    color: .orange
                ) {
                    HStack(spacing: 4) {
                        Text("\(Int(gitDefaults.activityThresholdDays))")
                            .font(.caption)
                            .frame(width: 25)
                        Slider(
                            value: $gitDefaults.activityThresholdDays,
                            in: 1...30,
                            step: 1
                        )
                        Text("git.settings.days".localized)
                            .font(.caption)
                    }
                }
            } header: {
                Text("git.settings.section.discovery".localized)
            }

            Section {
                SettingsRow(
                    title: "git.settings.showUncommittedCount".localized,
                    subtitle: "git.settings.showUncommittedCount.subtitle".localized,
                    icon: Image(systemName: "doc.badge"),
                    color: .orange
                ) {
                    Toggle("", isOn: $gitDefaults.showUncommittedCount)
                }

                SettingsRow(
                    title: "common.refreshInterval".localized,
                    subtitle: "git.settings.refreshInterval.subtitle".localized,
                    icon: Image(systemName: "arrow.clockwise"),
                    color: .blue
                ) {
                    HStack(spacing: 4) {
                        Text("\(Int(gitDefaults.refreshInterval))s")
                            .font(.caption)
                            .frame(width: 35)
                        Slider(
                            value: $gitDefaults.refreshInterval,
                            in: 15...120,
                            step: 15
                        )
                    }
                }
            } header: {
                Text("git.settings.section.display".localized)
            }
        }
        .formStyle(.grouped)
        .onAppear {
            scanPathsList = gitDefaults.scanPaths
        }
    }
}

#Preview {
    ExpandedGitStatusSettingsView()
}