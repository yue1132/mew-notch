//
//  ExpandedCalendarSettingsView.swift
//  MewNotch
//
//  Settings view for Calendar feature
//

import SwiftUI

struct ExpandedCalendarSettingsView: View {

    @StateObject private var calendarDefaults = CalendarDefaults.shared
    @StateObject private var calendarManager = CalendarManager.shared

    var body: some View {
        Form {
            Section {
                SettingsRow(
                    title: "calendar.settings.daysToShow".localized,
                    subtitle: "calendar.settings.daysToShow.subtitle".localized,
                    icon: Image(systemName: "calendar"),
                    color: .red
                ) {
                    Picker("", selection: $calendarDefaults.daysToShow) {
                        Text("1").tag(1)
                        Text("3").tag(3)
                        Text("7").tag(7)
                        Text("14").tag(14)
                    }
                    .frame(width: 60)
                }

                SettingsRow(
                    title: "calendar.settings.maxEvents".localized,
                    subtitle: "calendar.settings.maxEvents.subtitle".localized,
                    icon: Image(systemName: "list.bullet"),
                    color: .blue
                ) {
                    Picker("", selection: $calendarDefaults.maxEventsToShow) {
                        Text("3").tag(3)
                        Text("5").tag(5)
                        Text("10").tag(10)
                    }
                    .frame(width: 60)
                }

                SettingsRow(
                    title: "calendar.settings.showAllDay".localized,
                    subtitle: "calendar.settings.showAllDay.subtitle".localized,
                    icon: Image(systemName: "sun.max"),
                    color: .orange
                ) {
                    Toggle("", isOn: $calendarDefaults.showAllDay)
                }
            } header: {
                Text("calendar.settings.section.display".localized)
            }

            Section {
                SettingsRow(
                    title: "calendar.settings.showReminders".localized,
                    subtitle: "calendar.settings.showReminders.subtitle".localized,
                    icon: Image(systemName: "checklist"),
                    color: .purple
                ) {
                    Toggle("", isOn: $calendarDefaults.showReminders)
                }
            } header: {
                Text("calendar.settings.section.reminders".localized)
            }

            Section {
                SettingsRow(
                    title: "common.refreshInterval".localized,
                    subtitle: "calendar.settings.refreshInterval.subtitle".localized,
                    icon: Image(systemName: "arrow.clockwise"),
                    color: .green
                ) {
                    HStack(spacing: 4) {
                        Text("\(Int(calendarDefaults.refreshInterval / 60))")
                            .font(.caption)
                            .frame(width: 25)
                        Slider(
                            value: $calendarDefaults.refreshInterval,
                            in: 60...600,
                            step: 60
                        )
                        Text("common.minutes".localized)
                            .font(.caption)
                    }
                }
            } header: {
                Text("calendar.settings.section.sync".localized)
            }

            // Authorization status
            if !calendarManager.isAuthorized {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Label {
                            Text("calendar.authorizationRequired".localized)
                        } icon: {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.orange)
                        }
                        .font(.caption)

                        Button {
                            Task {
                                _ = await calendarManager.requestAccess()
                            }
                        } label: {
                            Text("calendar.authorize".localized)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } header: {
                    Text("calendar.settings.section.permissions".localized)
                }
            }
        }
        .formStyle(.grouped)
    }
}

#Preview {
    ExpandedCalendarSettingsView()
}
