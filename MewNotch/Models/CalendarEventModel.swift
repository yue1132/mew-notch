//
//  CalendarEventModel.swift
//  MewNotch
//

import Foundation
import EventKit

struct CalendarEventModel: Identifiable {
    let id: String
    var title: String
    var startTime: Date
    var endTime: Date
    var location: String?
    var calendarName: String
    var isAllDay: Bool

    static func fromEKEvent(_ event: EKEvent) -> CalendarEventModel {
        return CalendarEventModel(
            id: event.eventIdentifier,
            title: event.title ?? "Untitled",
            startTime: event.startDate,
            endTime: event.endDate,
            location: event.location,
            calendarName: event.calendar?.title ?? "Unknown",
            isAllDay: event.isAllDay
        )
    }

    var isPast: Bool {
        return endTime < Date()
    }

    var isOngoing: Bool {
        return startTime <= Date() && endTime > Date()
    }

    var isUpcoming: Bool {
        return startTime > Date()
    }

    var durationMinutes: Int {
        let interval = endTime.timeIntervalSince(startTime)
        return Int(interval / 60)
    }

    var formattedStartTime: String {
        if isAllDay {
            return "All Day"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: startTime)
    }

    var formattedEndTime: String {
        if isAllDay {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: endTime)
    }

    var formattedTimeRange: String {
        if isAllDay {
            return "All Day"
        }
        return "\(formattedStartTime) - \(formattedEndTime)"
    }

    var relativeTimeString: String {
        if isAllDay {
            return "Today"
        }
        if isOngoing {
            let remaining = Int(endTime.timeIntervalSince(Date()) / 60)
            return "Ends in \(remaining) min"
        }
        if isUpcoming {
            let minutesUntil = Int(startTime.timeIntervalSince(Date()) / 60)
            if minutesUntil < 60 {
                return "In \(minutesUntil) min"
            } else {
                let hours = minutesUntil / 60
                return "In \(hours)h"
            }
        }
        return "Past"
    }
}