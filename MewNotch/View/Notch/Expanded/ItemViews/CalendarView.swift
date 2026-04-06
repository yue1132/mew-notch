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

    private var cardWidth: CGFloat {
        notchViewModel.notchSize.height * 6
    }

    private var cardHeight: CGFloat {
        notchViewModel.notchSize.height * 3
    }

    var body: some View {
        VStack(spacing: 0) {
            if !calendarManager.isAuthorized {
                authorizationRequiredView
            } else if calendarManager.isRefreshing && calendarManager.todayEvents.isEmpty && calendarManager.upcomingReminders.isEmpty {
                loadingView
            } else if calendarManager.todayEvents.isEmpty && calendarManager.upcomingReminders.isEmpty {
                emptyStateView
            } else {
                contentView
            }
        }
        .frame(width: cardWidth, height: cardHeight)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.3))
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear {
            if calendarManager.isAuthorized {
                calendarManager.refreshData()
            } else {
                Task {
                    _ = await calendarManager.requestAccess()
                }
            }
        }
    }

    // MARK: - Subviews

    private var authorizationRequiredView: some View {
        VStack(spacing: 8) {
            Spacer()

            Image(systemName: "calendar.badge.lock")
                .font(.system(size: 22))
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
                    .font(.system(size: 10, weight: .medium))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .buttonStyle(.plain)

            Button {
                calendarManager.openPrivacySettings()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "gear")
                        .font(.system(size: 8))
                    Text("calendar.openSettings".localized)
                        .font(.system(size: 9))
                }
                .foregroundColor(.gray.opacity(0.7))
            }
            .buttonStyle(.plain)

            Spacer()
        }
    }

    private var loadingView: some View {
        VStack(spacing: 6) {
            Spacer()
            ProgressView()
                .scaleEffect(0.8)
                .tint(.white)
            Text("calendar.loading".localized)
                .font(.system(size: 10))
                .foregroundColor(.gray)
            Spacer()
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 6) {
            Spacer()
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 20))
                .foregroundColor(.gray)
            Text("calendar.noEvents".localized)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.gray.opacity(0.8))
            Text("calendar.addEvent".localized)
                .font(.system(size: 8))
                .foregroundColor(.gray.opacity(0.6))
            Spacer()
        }
        .onTapGesture {
            calendarManager.openCalendarApp()
        }
    }

    // MARK: - Content

    private var contentView: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 6) {
                    // Events
                    if !calendarManager.todayEvents.isEmpty {
                        sectionHeader(icon: "calendar", title: "calendar.events".localized, color: .blue)
                            .padding(.top, 4)

                        ForEach(calendarManager.todayEvents) { event in
                            EventRowView(event: event)
                                .opacity(event.isPast ? 0.45 : 1.0)
                        }
                    }

                    // Reminders
                    if calendarDefaults.showReminders && !calendarManager.upcomingReminders.isEmpty {
                        if !calendarManager.todayEvents.isEmpty {
                            Divider()
                                .background(Color.white.opacity(0.15))
                                .padding(.horizontal, 8)
                        }

                        sectionHeader(icon: "checklist", title: "calendar.reminders".localized, color: .orange)

                        ForEach(calendarManager.upcomingReminders) { reminder in
                            ReminderRowView(reminder: reminder)
                        }
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
            }
            .frame(maxHeight: .infinity)
        }
    }

    private func sectionHeader(icon: String, title: String, color: Color) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 9))
                .foregroundColor(color)
            Text(title)
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Event Row

struct EventRowView: View {
    let event: CalendarEventModel
    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 8) {
            // Time column
            VStack(alignment: .trailing, spacing: 1) {
                if event.isAllDay {
                    Text("calendar.allDay".localized)
                        .font(.system(size: 8, weight: .semibold))
                        .foregroundColor(.gray)
                } else {
                    Text(formatTime(event.startDate))
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(event.isNow ? .blue : .white)
                        .monospacedDigit()
                    Text(formatTime(event.endDate))
                        .font(.system(size: 7, design: .monospaced))
                        .foregroundColor(.gray)
                        .monospacedDigit()
                }
            }
            .frame(width: 40)

            // Color bar
            RoundedRectangle(cornerRadius: 2)
                .fill(event.calendarColor?.color ?? .blue)
                .frame(width: 3, height: event.isAllDay ? 16 : 28)

            // Title + calendar
            VStack(alignment: .leading, spacing: 2) {
                Text(event.title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(isHovered ? 3 : 1)
                    .animation(.easeInOut(duration: 0.15), value: isHovered)

                if isHovered, let calName = event.calendarName {
                    Text(calName)
                        .font(.system(size: 8))
                        .foregroundColor(.gray.opacity(0.6))
                        .transition(.opacity)
                }
            }

            Spacer(minLength: 0)

            // Now indicator
            if event.isNow {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 6, height: 6)
                    .overlay(
                        Circle()
                            .fill(Color.blue.opacity(0.4))
                            .frame(width: 10, height: 10)
                    )
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(backgroundFill)
        )
        .onHover { isHovered = $0 }
        .onTapGesture {
            if let identifier = event.eventIdentifier {
                CalendarManager.shared.openEvent(identifier: identifier)
            } else {
                CalendarManager.shared.openCalendarApp()
            }
        }
    }

    private var backgroundFill: Color {
        if event.isNow {
            return Color.blue.opacity(0.12)
        } else if isHovered {
            return Color.white.opacity(0.1)
        } else {
            return Color.white.opacity(0.04)
        }
    }

    private func formatTime(_ date: Date) -> String {
        let f = DateFormatter()
        f.timeStyle = .short
        f.dateStyle = .none
        return f.string(from: date)
    }
}

// MARK: - Reminder Row

struct ReminderRowView: View {
    let reminder: ReminderModel
    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 13))
                .foregroundColor(reminder.isCompleted ? .green : .gray)

            Text(reminder.title)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(reminder.isCompleted ? .gray : .white)
                .strikethrough(reminder.isCompleted)
                .lineLimit(isHovered ? 3 : 1)
                .animation(.easeInOut(duration: 0.15), value: isHovered)

            Spacer(minLength: 0)

            if let dueDate = reminder.dueDate {
                Text(formatTime(dueDate))
                    .font(.system(size: 8, weight: .medium))
                    .foregroundColor(reminder.isOverdue ? .red : .gray)
                    .monospacedDigit()
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isHovered ? Color.white.opacity(0.1) : Color.white.opacity(0.04))
        )
        .onHover { isHovered = $0 }
    }

    private func formatTime(_ date: Date) -> String {
        let f = DateFormatter()
        f.timeStyle = .short
        f.dateStyle = .none
        return f.string(from: date)
    }
}

#Preview {
    if let screen = NSScreen.main {
        CalendarView(notchViewModel: NotchViewModel(screen: screen))
    }
}
