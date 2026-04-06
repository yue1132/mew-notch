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
    case Bluetooth
    case Calendar
    case SystemMonitor
    case Timer

    var displayName: String {
        switch self {
        case .Mirror:
            return "item.mirror".localized
        case .NowPlaying:
            return "item.nowPlaying".localized
        case .Bash:
            return "item.bash".localized
        case .Bluetooth:
            return "item.bluetooth".localized
        case .Calendar:
            return "item.calendar".localized
        case .SystemMonitor:
            return "item.systemMonitor".localized
        case .Timer:
            return "item.timer".localized
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
        case .Bluetooth:
            return "bluetooth"
        case .Calendar:
            return "calendar"
        case .SystemMonitor:
            return "cpu"
        case .Timer:
            return "timer"
        }
    }
}
