//
//  NotchDisplayVisibility.swift
//  MewNotch
//
//  Created by Monu Kumar on 28/04/25.
//

import Foundation

enum NotchDisplayVisibility: String, CaseIterable, Codable, Identifiable {
    var id: String {
        self.rawValue
    }
    
    case AllDisplays
    case NotchedDisplayOnly
    
    case Custom
    
    var displayName: String {
        switch self {
        case .AllDisplays:
            return "display.allDisplays".localized
        case .NotchedDisplayOnly:
            return "display.notchedOnly".localized
        case .Custom:
            return "display.custom".localized
        }
    }
}
