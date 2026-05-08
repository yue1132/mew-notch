//
//  CalendarSettingsView.swift
//  MewNotch
//

import SwiftUI
import EventKit

struct CalendarSettingsView: View {

    @ObservedObject var defaults = CalendarDefaults.shared
    @StateObject var calendarManager = CalendarManager.shared

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Permission
                if !calendarManager.hasPermission {
                    VStack(spacing: 12) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.gray)

                        Text("calendar_access_denied")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)

                        Button("grant_calendar_access") {
                            calendarManager.requestPermission()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                }

                // Display settings
                SettingsRow(
                    title: "show_today_events",
                    icon: Image(systemName: "sun.max.fill"),
                    color: MewNotch.Colors.brightness
                ) {
                    Toggle("", isOn: $defaults.showTodayEvents)
                        .toggleStyle(.switch)
                        .scaleEffect(0.7)
                }

                SettingsRow(
                    title: "show_tomorrow_events",
                    icon: Image(systemName: "moon.fill"),
                    color: MewNotch.Colors.hud
                ) {
                    Toggle("", isOn: $defaults.showTomorrowEvents)
                        .toggleStyle(.switch)
                        .scaleEffect(0.7)
                }

                SettingsRow(
                    title: "show_ongoing_events",
                    icon: Image(systemName: "clock.fill"),
                    color: MewNotch.Colors.timer
                ) {
                    Toggle("", isOn: $defaults.showOngoingEvents)
                        .toggleStyle(.switch)
                        .scaleEffect(0.7)
                }

                SettingsRow(
                    title: "show_past_events",
                    icon: Image(systemName: "arrow.backward"),
                    color: MewNotch.Colors.timer
                ) {
                    Toggle("", isOn: $defaults.showPastEvents)
                        .toggleStyle(.switch)
                        .scaleEffect(0.7)
                }

                SettingsRow(
                    title: "max_events_to_show",
                    icon: Image(systemName: "number.circle"),
                    color: MewNotch.Colors.todoReminder
                ) {
                    Picker("", selection: $defaults.maxEventsToShow) {
                        ForEach(1...10, id: \.self) { count in
                            Text("\(count)").tag(count)
                        }
                    }
                    .frame(width: 60)
                }

                SettingsRow(
                    title: "hud_reminder_minutes",
                    icon: MewNotch.Assets.icHud,
                    color: MewNotch.Colors.hud
                ) {
                    Picker("", selection: $defaults.hudReminderMinutes) {
                        ForEach([5, 10, 15, 30, 60], id: \.self) { min in
                            Text("\(min)").tag(min)
                        }
                    }
                    .frame(width: 60)
                }

                Divider()

                // Calendar selection
                if calendarManager.hasPermission {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("select_calendars")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)

                        ForEach(calendarManager.getCalendarList(), id: \.0) { (id, name) in
                            HStack {
                                Text(name)
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)

                                Spacer()

                                Toggle("", isOn: Binding(
                                    get: { defaults.selectedCalendars.contains(id) },
                                    set: { enabled in
                                        if enabled {
                                            defaults.selectedCalendars.append(id)
                                        } else {
                                            defaults.selectedCalendars.removeAll { $0 == id }
                                        }
                                    }
                                ))
                                .toggleStyle(.checkbox)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("calendar")
    }
}