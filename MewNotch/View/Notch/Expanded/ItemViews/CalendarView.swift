//
//  CalendarView.swift
//  MewNotch
//

import SwiftUI

struct CalendarView: View {

    @ObservedObject var viewModel = CalendarViewModel.shared
    @ObservedObject var notchViewModel: NotchViewModel

    var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(MewNotch.Colors.calendarWidget.color)

                Text(viewModel.formatDateHeader())
                    .font(.system(size: 14, weight: .semibold))

                Spacer()

                Button {
                    viewModel.refreshEvents()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.gray)
                }
                .buttonStyle(.plain)
            }

            // Permission check
            if !viewModel.hasPermission {
                VStack(spacing: 12) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.gray)

                    Text("calendar_access_required")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)

                    Button {
                        viewModel.requestPermission()
                    } label: {
                        Text("grant_access")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    .help("Click to grant calendar access in System Settings")
                }
                .frame(height: 150)
            } else if viewModel.todayEvents.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.orange.opacity(0.5))

                    Text("no_events_today")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .frame(height: 150)
            } else {
                // Events list
                ScrollView {
                    LazyVStack(spacing: 8) {
                        // Ongoing event highlight
                        if let ongoing = viewModel.getOngoingEvent() {
                            CalendarEventRow(event: ongoing, isHighlighted: true)
                        }

                        // Upcoming events
                        ForEach(viewModel.todayEvents.filter { $0.isUpcoming }) { event in
                            CalendarEventRow(event: event)
                        }
                    }
                }
                .frame(height: 150)
            }

            // Footer
            HStack {
                if let nextEvent = viewModel.getNextEvent() {
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 10))

                        Text("next: \(nextEvent.title)")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                }

                Spacer()

                Text("\(viewModel.todayEvents.count) events")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
        }
        .padding(12)
    }
}

struct CalendarEventRow: View {

    let event: CalendarEventModel
    var isHighlighted: Bool = false

    @ObservedObject var viewModel = CalendarViewModel.shared

    var body: some View {
        HStack(spacing: 12) {
            // Time indicator
            VStack(alignment: .center, spacing: 2) {
                Text(event.formattedStartTime)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(isHighlighted ? .blue : .white)

                if !event.isAllDay {
                    Text(event.formattedEndTime)
                        .font(.system(size: 9))
                        .foregroundColor(.gray.opacity(0.5))
                }
            }
            .frame(width: 50)

            // Divider
            Rectangle()
                .fill(viewModel.getEventColor(event))
                .frame(width: 3, height: 40)
                .cornerRadius(1.5)

            // Event info
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(1)

                if let location = event.location {
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 9))
                            .foregroundColor(.gray.opacity(0.7))

                        Text(location)
                            .font(.system(size: 10))
                            .foregroundColor(.gray.opacity(0.7))
                            .lineLimit(1)
                    }
                }

                if event.isOngoing {
                    Text(event.relativeTimeString)
                        .font(.system(size: 10))
                        .foregroundColor(.blue)
                }
            }

            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(isHighlighted ? Color.blue.opacity(0.2) : Color.white.opacity(0.05))
        .cornerRadius(6)
    }
}