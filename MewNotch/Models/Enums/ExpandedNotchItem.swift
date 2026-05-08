//
//  ExpandedNotchItem.swift
//  MewNotch
//
//  Created by Monu Kumar on 28/04/25.
//


enum ExpandedNotchItem: String, CaseIterable, Codable, Identifiable {
    var id: String {
        self.rawValue
    }

    case Mirror
    case NowPlaying
    case Bash
    case Teleprompter
    case TodoReminder
    case Timer
    case Pomodoro
    case Calendar

    var displayName: String {
        switch self {
        case .Mirror:
            return "Mirror"
        case .NowPlaying:
            return "Now Playing"
        case .Bash:
            return "Bash Command"
        case .Teleprompter:
            return "Teleprompter"
        case .TodoReminder:
            return "Todo & Reminder"
        case .Timer:
            return "Timer"
        case .Pomodoro:
            return "Pomodoro"
        case .Calendar:
            return "Calendar"
        }
    }

    var imageSystemName: String {
        switch self {
        case .Mirror:
            return "video.fill"
        case .NowPlaying:
            return "music.note"
        case .Bash:
            return "terminal"
        case .Teleprompter:
            return "text.alignleft"
        case .TodoReminder:
            return "checklist"
        case .Timer:
            return "timer"
        case .Pomodoro:
            return "clock.fill"
        case .Calendar:
            return "calendar"
        }
    }
}
