//
//  ProductivityMiniViews.swift
//  MewNotch
//

import SwiftUI

// Teleprompter Mini View
struct TeleprompterMiniView: View {

    @ObservedObject var notchViewModel: NotchViewModel
    @ObservedObject var viewModel = TeleprompterViewModel.shared

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "text.alignleft")
                .font(.system(size: 20))
                .foregroundColor(MewNotch.Colors.teleprompter.color)

            if viewModel.currentText.isEmpty {
                Text("no_script")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            } else {
                Text(viewModel.importedFileName ?? "Script")
                    .font(.system(size: 10))
                    .foregroundColor(.white)
                    .lineLimit(1)

                if viewModel.isScrolling {
                    Image(systemName: "play.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.green)
                }
            }
        }
        .frame(width: 80, height: notchViewModel.notchSize.height * 3 - 20)
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
        .onTapGesture {
            NotificationCenter.default.post(name: NSNotification.Name("SwitchToTeleprompter"), object: nil)
        }
    }
}

// Todo Reminder Mini View
struct TodoReminderMiniView: View {

    @ObservedObject var notchViewModel: NotchViewModel
    @ObservedObject var viewModel = TodoReminderViewModel.shared

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "checklist")
                .font(.system(size: 20))
                .foregroundColor(MewNotch.Colors.todoReminder.color)

            if viewModel.badgeCount > 0 {
                Text("\(viewModel.badgeCount)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)

                if viewModel.overdueCount > 0 {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.red)
                }
            } else {
                Text("✓")
                    .font(.system(size: 20))
                    .foregroundColor(.green.opacity(0.5))
            }
        }
        .frame(width: 80, height: notchViewModel.notchSize.height * 3 - 20)
        .background(viewModel.overdueCount > 0 ? Color.red.opacity(0.1) : Color.white.opacity(0.05))
        .cornerRadius(8)
        .onTapGesture {
            NotificationCenter.default.post(name: NSNotification.Name("SwitchToTodoReminder"), object: nil)
        }
    }
}

// Timer Mini View
struct TimerMiniView: View {

    @ObservedObject var notchViewModel: NotchViewModel
    @ObservedObject var viewModel = TimerViewModel.shared

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "timer")
                .font(.system(size: 20))
                .foregroundColor(MewNotch.Colors.timerWidget.color)

            if let timer = viewModel.activeTimer {
                Text(timer.formattedTime)
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(timer.state == .running ? .orange : .gray)

                ProgressView(value: timer.progress)
                    .tint(.orange)
                    .frame(width: 50)
            } else {
                Text("--:--")
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(.gray.opacity(0.5))
            }
        }
        .frame(width: 80, height: notchViewModel.notchSize.height * 3 - 20)
        .background(viewModel.activeTimer?.state == .running ? Color.orange.opacity(0.1) : Color.white.opacity(0.05))
        .cornerRadius(8)
        .onTapGesture {
            NotificationCenter.default.post(name: NSNotification.Name("SwitchToTimer"), object: nil)
        }
    }
}

// Pomodoro Mini View
struct PomodoroMiniView: View {

    @ObservedObject var notchViewModel: NotchViewModel
    @ObservedObject var pomodoroManager = PomodoroManager.shared

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: getSessionIcon())
                .font(.system(size: 20))
                .foregroundColor(getSessionColor())

            Text(pomodoroManager.session.formattedTime)
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .foregroundColor(getSessionColor())

            Text(getSessionStatus())
                .font(.system(size: 10))
                .foregroundColor(getSessionColor().opacity(0.8))
        }
        .frame(width: 80, height: notchViewModel.notchSize.height * 3 - 20)
        .background(pomodoroManager.session.state == .running ? getSessionColor().opacity(0.1) : Color.white.opacity(0.05))
        .cornerRadius(8)
        .onTapGesture {
            NotificationCenter.default.post(name: NSNotification.Name("SwitchToPomodoro"), object: nil)
        }
    }

    private func getSessionColor() -> Color {
        switch pomodoroManager.session.currentSessionType {
        case .work: return .red
        case .shortBreak: return .green
        case .longBreak: return .blue
        }
    }

    private func getSessionIcon() -> String {
        switch pomodoroManager.session.currentSessionType {
        case .work: return "brain.head.profile"
        case .shortBreak: return "cup.and.saucer.fill"
        case .longBreak: return "figure.walk"
        }
    }

    private func getSessionStatus() -> LocalizedStringKey {
        switch pomodoroManager.session.currentSessionType {
        case .work: return "focus"
        case .shortBreak: return "break"
        case .longBreak: return "break"
        }
    }
}

// Calendar Mini View
struct CalendarMiniView: View {

    @ObservedObject var notchViewModel: NotchViewModel
    @ObservedObject var viewModel = CalendarViewModel.shared

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "calendar")
                .font(.system(size: 20))
                .foregroundColor(MewNotch.Colors.calendarWidget.color)

            if let event = viewModel.getNextEvent() {
                Text(event.formattedStartTime)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)

                Text(event.title)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            } else if let ongoing = viewModel.getOngoingEvent() {
                Image(systemName: "clock.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.blue)

                Text(ongoing.title)
                    .font(.system(size: 10))
                    .foregroundColor(.white)
                    .lineLimit(1)
            } else {
                Text("no_events")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 80, height: notchViewModel.notchSize.height * 3 - 20)
        .background(viewModel.getOngoingEvent() != nil ? Color.blue.opacity(0.1) : Color.white.opacity(0.05))
        .cornerRadius(8)
        .onTapGesture {
            NotificationCenter.default.post(name: NSNotification.Name("SwitchToCalendar"), object: nil)
        }
    }
}