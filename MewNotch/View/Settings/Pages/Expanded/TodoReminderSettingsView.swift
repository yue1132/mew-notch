//
//  TodoReminderSettingsView.swift
//  MewNotch
//

import SwiftUI
import EventKit

struct TodoReminderSettingsView: View {

    @ObservedObject var todoDefaults = TodoDefaults.shared
    @ObservedObject var reminderDefaults = ReminderIntegrationDefaults.shared
    @StateObject var reminderManager = ReminderManager.shared

    @State private var newTodoTitle: String = ""
    @State private var showAddTodo: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Badge settings
                SettingsRow(
                    title: "show_badge_count",
                    icon: Image(systemName: "number.circle"),
                    color: MewNotch.Colors.todoReminder
                ) {
                    Toggle("", isOn: $todoDefaults.showBadgeCount)
                        .toggleStyle(.switch)
                        .scaleEffect(0.7)
                }

                SettingsRow(
                    title: "hud_reminder_enabled",
                    icon: MewNotch.Assets.icHud,
                    color: MewNotch.Colors.hud
                ) {
                    Toggle("", isOn: $todoDefaults.hudReminderEnabled)
                        .toggleStyle(.switch)
                        .scaleEffect(0.7)
                }

                SettingsRow(
                    title: "reminder_sound",
                    icon: Image(systemName: "speaker.wave.2.fill"),
                    color: MewNotch.Colors.audio
                ) {
                    Toggle("", isOn: $todoDefaults.reminderSound)
                        .toggleStyle(.switch)
                        .scaleEffect(0.7)
                }

                SettingsRow(
                    title: "sort_by_priority",
                    icon: Image(systemName: "arrow.up.arrow.down"),
                    color: MewNotch.Colors.timer
                ) {
                    Toggle("", isOn: $todoDefaults.sortByPriority)
                        .toggleStyle(.switch)
                        .scaleEffect(0.7)
                }

                Divider()

                // Apple Reminders integration
                VStack(alignment: .leading, spacing: 12) {
                    Text("apple_reminders_integration")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)

                    SettingsRow(
                            title: "enable_sync",
                            icon: Image(systemName: "link"),
                            color: MewNotch.Colors.calendarWidget
                        ) {
                            Toggle("", isOn: $reminderDefaults.appleRemindersEnabled)
                                .toggleStyle(.switch)
                                .scaleEffect(0.7)
                        }

                    if reminderDefaults.appleRemindersEnabled {
                        if !reminderManager.hasPermission {
                            Button("grant_reminders_access") {
                                reminderManager.requestPermission()
                            }
                            .buttonStyle(.borderedProminent)
                        } else {
                            SettingsRow(
                                title: "sync_interval",
                                icon: Image(systemName: "clock.arrow.circlepath"),
                                color: MewNotch.Colors.timer
                            ) {
                                Picker("", selection: $reminderDefaults.syncIntervalMinutes) {
                                    Text("1 min").tag(1)
                                    Text("5 min").tag(5)
                                    Text("10 min").tag(10)
                                    Text("30 min").tag(30)
                                }
                                .frame(width: 80)
                            }

                            // Calendar list selection
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Select Lists")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)

                                ForEach(reminderManager.getReminderLists(), id: \.0) { (id, name) in
                                    HStack {
                                        Text(name)
                                            .font(.system(size: 12))
                                            .foregroundColor(.white)

                                        Spacer()

                                        Toggle("", isOn: Binding(
                                            get: { reminderDefaults.selectedLists.contains(id) },
                                            set: { enabled in
                                                if enabled {
                                                    reminderDefaults.selectedLists.append(id)
                                                } else {
                                                    reminderDefaults.selectedLists.removeAll { $0 == id }
                                                }
                                            }
                                        ))
                                        .toggleStyle(.checkbox)
                                    }
                                }
                            }
                        }
                    }
                }

                Divider()

                // Local todos management
                VStack(alignment: .leading, spacing: 12) {
                    Text("local_todos")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)

                    Button {
                        showAddTodo.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("add_todo")
                        }
                        .foregroundColor(.green)
                    }
                    .buttonStyle(.plain)

                    if showAddTodo {
                        HStack {
                            TextField("todo_title", text: $newTodoTitle)
                                .textFieldStyle(.roundedBorder)

                            Button("add") {
                                if !newTodoTitle.isEmpty {
                                    let todo = TodoItemModel(title: newTodoTitle)
                                    todoDefaults.items.append(todo)
                                    newTodoTitle = ""
                                    showAddTodo = false
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }

                    if !todoDefaults.items.filter({ $0.source == .local }).isEmpty {
                        ForEach(todoDefaults.items.filter { $0.source == .local }) { item in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.title)
                                        .font(.system(size: 12))
                                        .foregroundColor(item.isCompleted ? .gray : .white)
                                        .strikethrough(item.isCompleted)

                                    if let dueDate = item.dueDate {
                                        Text(formatDate(dueDate))
                                            .font(.system(size: 10))
                                            .foregroundColor(.gray)
                                    }
                                }

                                Spacer()

                                Button {
                                    if let index = todoDefaults.items.firstIndex(where: { $0.id == item.id }) {
                                        todoDefaults.items[index].isCompleted.toggle()
                                    }
                                } label: {
                                    Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(item.isCompleted ? .green : .gray)
                                }
                                .buttonStyle(.plain)

                                Button {
                                    todoDefaults.items.removeAll { $0.id == item.id }
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(4)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("todo_reminder")
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}