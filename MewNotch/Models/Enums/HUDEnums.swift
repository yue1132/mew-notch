//
//  HUDEnums.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//

import Foundation

enum HUDStyle: String, CaseIterable, Identifiable, Codable {
    var id: String { rawValue }

    case Minimal
    case Progress
    case Notched

    var displayName: String {
        switch self {
        case .Minimal:
            return "hudStyle.minimal".localized
        case .Progress:
            return "hudStyle.progress".localized
        case .Notched:
            return "hudStyle.notched".localized
        }
    }
}
