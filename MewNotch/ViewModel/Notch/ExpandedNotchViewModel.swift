//
//  ExpandedNotchViewModel.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/03/25.
//

import SwiftUI

class ExpandedNotchViewModel: ObservableObject {
    
    enum NotchViewType: String, CaseIterable, Identifiable {
        var id: String {
            self.rawValue
        }

        case Home
        case Shelf
        case Teleprompter
        case TodoReminder
        case Timer
        case Pomodoro
        case Calendar

        var imageSystemName: String {
            switch self {
            case .Home:
                return "house"
            case .Shelf:
                return "folder"
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
    
    @Published var currentView: NotchViewType = .Home
    
    @Published var nowPlayingMedia: NowPlayingMediaModel?
    
    @Published var shelfFileGroups: [ShelfFileGroupModel] = [] {
        didSet {
            ShelfDefaults.shared.shelfFileGroups = shelfFileGroups
        }
    }
    
    init() {
        self.startListeners()
        
        self.nowPlayingMedia = NowPlaying.shared.nowPlayingModel
        
        self.shelfFileGroups = ShelfDefaults.shared.shelfFileGroups
    }
    
    deinit {
        self.stopListeners()
    }
    
    func startListeners() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNowPlayingMediaChanges),
            name: NSNotification.Name.NowPlayingInfo,
            object: nil
        )

        // Productivity view switch listeners
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(switchToTeleprompter),
            name: NSNotification.Name("SwitchToTeleprompter"),
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(switchToTodoReminder),
            name: NSNotification.Name("SwitchToTodoReminder"),
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(switchToTimer),
            name: NSNotification.Name("SwitchToTimer"),
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(switchToPomodoro),
            name: NSNotification.Name("SwitchToPomodoro"),
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(switchToCalendar),
            name: NSNotification.Name("SwitchToCalendar"),
            object: nil
        )

        // Teleprompter shortcut
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(toggleTeleprompter),
            name: NSNotification.Name("ToggleTeleprompter"),
            object: nil
        )
    }

    @objc func switchToTeleprompter() {
        withAnimation {
            currentView = .Teleprompter
        }
    }

    @objc func switchToTodoReminder() {
        withAnimation {
            currentView = .TodoReminder
        }
    }

    @objc func switchToTimer() {
        withAnimation {
            currentView = .Timer
        }
    }

    @objc func switchToPomodoro() {
        withAnimation {
            currentView = .Pomodoro
        }
    }

    @objc func switchToCalendar() {
        withAnimation {
            currentView = .Calendar
        }
    }

    @objc func toggleTeleprompter() {
        withAnimation {
            if currentView == .Teleprompter {
                currentView = .Home
            } else {
                currentView = .Teleprompter
            }
        }
    }
    
    func stopListeners() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleNowPlayingMediaChanges() {
        guard let nowPlayingMedia = NowPlaying.shared.nowPlayingModel else {
            return
        }
        
        DispatchQueue.main.async {
            withAnimation {
                self.nowPlayingMedia = nowPlayingMedia
            }
        }
    }
    
}
