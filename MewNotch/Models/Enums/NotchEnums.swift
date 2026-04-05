//
//  NotchHeightMode.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import Foundation

enum NotchHeightMode: String, CaseIterable, Identifiable, Codable {
    var id: String { rawValue }
    
    case Match_Notch
    case Match_Menu_Bar
    case Manual
    
    var displayName: String {
        switch self {
        case .Match_Notch:
            return "heightMode.matchNotch".localized
        case .Match_Menu_Bar:
            return "heightMode.matchMenuBar".localized
        case .Manual:
            return "heightMode.manual".localized
        }
    }
}
    
