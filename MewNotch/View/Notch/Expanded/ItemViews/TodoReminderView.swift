//
//  TodoReminderView.swift
//  MewNotch
//

import SwiftUI

struct TodoReminderView: View {

    @ObservedObject var viewModel = TodoReminderViewModel.shared
    @ObservedObject var notchViewModel: NotchViewModel

    var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                Image(systemName: "checklist")
                    .foregroundColor(MewNotch.Colors.todoReminder.color)

                Text("todo_reminder")
                    .font(.system(size: 14, weight: .semibold))

                Spacer()

                // Badge
                if viewModel.badgeCount > 0 {
                    Text("\(viewModel.badgeCount)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(viewModel.overdueCount > 0 ? Color.red : Color.orange)
                        .cornerRadius(8)
                }
            }

            // Items list
            if viewModel.items.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.green.opacity(0.5))

                    Text("no_pending_items")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .frame(height: 150)
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.items) { item in
                            TodoItemRow(item: item)
                        }
                    }
                }
                .frame(height: 150)
            }

            // Footer info
            HStack {
                if viewModel.overdueCount > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 10))

                        Text("\(viewModel.overdueCount) overdue")
                            .font(.system(size: 10))
                            .foregroundColor(.red)
                    }
                }

                Spacer()

                if TodoReminderViewModel.shared.reminderDefaults.appleRemindersEnabled {
                    HStack(spacing: 4) {
                        Image(systemName: "link")
                            .foregroundColor(.blue)
                            .font(.system(size: 10))

                        Text("synced")
                            .font(.system(size: 10))
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding(12)
    }
}

struct TodoItemRow: View {

    let item: TodoItemModel

    @ObservedObject var viewModel = TodoReminderViewModel.shared

    var body: some View {
        HStack(spacing: 12) {
            // Priority indicator
            Circle()
                .fill(viewModel.getPriorityColor(item.priority))
                .frame(width: 8, height: 8)

            // Title
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                    .lineLimit(1)

                if let dueDate = item.dueDate {
                    Text(formatDueDate(dueDate))
                        .font(.system(size: 10))
                        .foregroundColor(item.isOverdue ? .red : .gray)
                }
            }

            Spacer()

            // Source indicator
            if item.source == .appleReminders {
                Image(systemName: "link")
                    .foregroundColor(.blue.opacity(0.5))
                    .font(.system(size: 10))
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(item.isOverdue ? Color.red.opacity(0.2) : Color.white.opacity(0.05))
        .cornerRadius(6)
    }

    private func formatDueDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current

        formatter.dateFormat = "HH:mm"
        let timeStr = formatter.string(from: date)

        if calendar.isDateInToday(date) {
            return String(localized: "today") + " " + timeStr
        } else if calendar.isDateInTomorrow(date) {
            return String(localized: "tomorrow") + " " + timeStr
        } else {
            formatter.dateFormat = "MMM d HH:mm"
            return formatter.string(from: date)
        }
    }
}