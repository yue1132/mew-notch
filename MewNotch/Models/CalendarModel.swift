//
//  CalendarModel.swift
//  MewNotch
//
//  Calendar event and reminder models
//

import Foundation
import SwiftUI

struct CalendarEventModel: Identifiable {
    let id = UUID()
    let title: String
    let startDate: Date
    let endDate: Date
    let isAllDay: Bool
    let calendarName: String?
    let calendarColor: CodableColor?

    var timeString: String {
        if isAllDay {
            return "calendar.allDay".localized
        }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: startDate)
    }

    var isNow: Bool {
        let now = Date()
        return now >= startDate && now <= endDate
    }

    var isPast: Bool {
        return Date() > endDate && !isAllDay
    }
}

struct ReminderModel: Identifiable {
    let id = UUID()
    let title: String
    let dueDate: Date?
    let isCompleted: Bool
    let priority: Int

    var isOverdue: Bool {
        guard let due = dueDate else { return false }
        return !isCompleted && Date() > due
    }
}

// Wrapper for Codable Color
struct CodableColor: Codable {
    let red: Double
    let green: Double
    let blue: Double

    var color: Color {
        Color(red: red, green: green, blue: blue)
    }
}

// Extension for CalendarEventModel to provide time string
extension CalendarEventModel {
    var displayTime: String {
        if isAllDay {
            return "calendar.allDay".localized
        }

        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let start = formatter.string(from: startDate)
        let end = formatter.string(from: endDate)
        return "\(start) - \(end)"
    }
}
