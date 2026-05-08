//
//  PomodoroView.swift
//  MewNotch
//

import SwiftUI

struct PomodoroView: View {

    @ObservedObject var viewModel = PomodoroViewModel.shared
    @ObservedObject var notchViewModel: NotchViewModel

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Image(systemName: viewModel.getSessionIcon())
                    .foregroundColor(viewModel.getSessionColor())

                Text(viewModel.session.currentSessionType == .work ? "focus_time" : "break")
                    .font(.system(size: 14, weight: .semibold))

                Spacer()

                // Session count
                Text("\(viewModel.session.sessionsCompleted)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange)
                    .cornerRadius(8)
            }

            // Timer display
            VStack(spacing: 8) {
                Text(viewModel.session.formattedTime)
                    .font(.system(size: 36, weight: .bold, design: .monospaced))
                    .foregroundColor(viewModel.getSessionColor())

                // Progress circle
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 8)
                        .frame(width: 100, height: 100)

                    Circle()
                        .trim(from: 0, to: viewModel.session.progress)
                        .stroke(viewModel.getSessionColor(), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(-90))
                }

                // Session type indicator
                Text(sessionTypeText())
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }

            // Controls
            HStack(spacing: 24) {
                if viewModel.session.state == .idle || viewModel.session.state == .paused {
                    Button {
                        viewModel.start()
                    } label: {
                        Image(systemName: "play.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.green)
                    }
                    .buttonStyle(.plain)
                } else if viewModel.session.state == .running {
                    Button {
                        viewModel.pause()
                    } label: {
                        Image(systemName: "pause.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.orange)
                    }
                    .buttonStyle(.plain)
                }

                Button {
                    viewModel.reset()
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                }
                .buttonStyle(.plain)

                Button {
                    viewModel.skip()
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                }
                .buttonStyle(.plain)
            }

            // Session info
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("work")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(viewModel.pomodoroDefaults.workDuration) min")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.red)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("short")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(viewModel.pomodoroDefaults.shortBreakDuration) min")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.green)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("long")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(viewModel.pomodoroDefaults.longBreakDuration) min")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.blue)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(8)
        }
        .padding(12)
    }

    private func sessionTypeText() -> LocalizedStringResource {
        switch viewModel.session.currentSessionType {
        case .work:
            return "focus_session"
        case .shortBreak:
            return "short_break"
        case .longBreak:
            return "long_break"
        }
    }
}