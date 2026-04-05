//
//  CalendarView.swift
//  MewNotch
//
//  View for displaying calendar events and reminders
//

import SwiftUI

struct CalendarView: View {

    @ObservedObject var notchViewModel: NotchViewModel
    @StateObject private var calendarManager = CalendarManager.shared
    @StateObject private var calendarDefaults = CalendarDefaults.shared

    var body: some View {
        VStack(spacing: 8) {
            if !calendarManager.isAuthorized {
                authorizationRequiredView
            } else if calendarManager.isRefreshing && calendarManager.todayEvents.isEmpty {
                loadingView
            } else if calendarManager.todayEvents.isEmpty && calendarManager.upcomingReminders.isEmpty {
                emptyStateView
            } else {
                contentView
            }
        }
        .padding(8)
        .frame(
            width: notchViewModel.notchSize.height * 4,
            height: notchViewModel.notchSize.height * 3
        )
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.3))
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear {
            if calendarManager.isAuthorized {
                calendarManager.refreshData()
            }
        }
    }

    // MARK: - Subviews

    private var authorizationRequiredView: some View {
        VStack(spacing: 8) {
            Image(systemName: "calendar.badge.lock")
                .font(.system(size: 24))
                .foregroundColor(.gray)

            Text("calendar.authorizationRequired".localized)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.gray.opacity(0.8))
                .multilineTextAlignment(.center)

            Button {
                Task {
                    _ = await calendarManager.requestAccess()
                }
            } label: {
                Text("calendar.authorize".localized)
                    .font(.system(size: 10))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(6)
            }
            .buttonStyle(.plain)
        }
    }

    private var loadingView: some View {
        VStack(spacing: 6) {
            ProgressView()
                .scaleEffect(0.7)
                .tint(.white)

            Text("calendar.loading".localized)
                .font(.system(size: 10))
                .foregroundColor(.gray)
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 6) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 20))
                .foregroundColor(.gray)

            Text("calendar.noEvents".localized)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.gray.opacity(0.8))

            Text("calendar.addEvent".localized)
                .font(.system(size: 8))
                .foregroundColor(.gray.opacity(0.6))
        }
        .onTapGesture {
            calendarManager.openCalendarApp()
        }
    }

    private var contentView: some View {
        VStack(spacing: 4) {
            // Events section
            if !calendarManager.todayEvents.isEmpty {
                eventsSection
            }

            // Reminders section
            if calendarDefaults.showReminders && !calendarManager.upcomingReminders.isEmpty {
                Divider()
                    .background(Color.white.opacity(0.2))

                remindersSection
            }
        }
    }

    private var eventsSection: some View {
        VStack(spacing: 3) {
            ForEach(calendarManager.todayEvents) { event in
                EventRowView(event: event)
                    .opacity(event.isPast ? 0.5 : 1.0)
            }
        }
    }

    private var remindersSection: some View {
        VStack(spacing: 3) {
            ForEach(calendarManager.upcomingReminders) { reminder in
                ReminderRowView(reminder: reminder)
            }
        }
    }
}

// MARK: - Event Row

struct EventRowView: View {
    let event: CalendarEventModel

    var body: some View {
        HStack(spacing: 8) {
            // Color indicator
            RoundedRectangle(cornerRadius: 2)
                .fill(event.calendarColor?.color ?? .blue)
                .frame(width: 3, height: 28)

            // Time
            Text(event.displayTime)
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(event.isNow ? .blue : .gray)
                .frame(width: 50, alignment: .leading)

            // Title
            VStack(alignment: .leading, spacing: 2) {
                Text(event.title)
                    .font(.system(size: 10))
                    .foregroundColor(.white)
                    .lineLimit(1)

                if let calendarName = event.calendarName {
                    Text(calendarName)
                        .font(.system(size: 8))
                        .foregroundColor(.gray.opacity(0.6))
                        .lineLimit(1)
                }
            }

            Spacer()

            // Now indicator
            if event.isNow {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 6, height: 6)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(event.isNow ? Color.blue.opacity(0.15) : Color.white.opacity(0.05))
        )
    }
}

// MARK: - Reminder Row

struct ReminderRowView: View {
    let reminder: ReminderModel

    var body: some View {
        HStack(spacing: 8) {
            // Checkbox
            Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 12))
                .foregroundColor(reminder.isCompleted ? .green : .gray)

            // Title
            Text(reminder.title)
                .font(.system(size: 10))
                .foregroundColor(reminder.isCompleted ? .gray : .white)
                .strikethrough(reminder.isCompleted)
                .lineLimit(1)

            Spacer()

            // Due time
            if let dueDate = reminder.dueDate {
                Text(formatTime(dueDate))
                    .font(.system(size: 8))
                    .foregroundColor(reminder.isOverdue ? .red : .gray)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.white.opacity(0.05))
        )
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: date)
    }
}

#Preview {
    if let screen = NSScreen.main {
        CalendarView(notchViewModel: NotchViewModel(screen: screen))
    }
}
