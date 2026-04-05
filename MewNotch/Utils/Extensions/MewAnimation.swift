//
//  MewAnimation.swift
//  MewNotch
//
//  Unified animation constants for consistent UX
//

import SwiftUI

enum MewAnimation {

    /// Notch expand/collapse
    static let expand = Animation.spring(.bouncy(duration: 0.4, extraBounce: 0.1))

    /// Hover scale effect
    static let hover = Animation.spring(response: 0.3, dampingFraction: 0.7)

    /// HUD show/hide
    static let hud = Animation.easeOut(duration: 0.25)

    /// General content transitions
    static let transition = Animation.spring(response: 0.35, dampingFraction: 0.8)

    /// Subtle fade
    static let fade = Animation.easeInOut(duration: 0.2)
}
