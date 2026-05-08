//
//  TeleprompterShortcutManager.swift
//  MewNotch
//

import Foundation
import Carbon
import SwiftUI

class TeleprompterShortcutManager {

    static let shared = TeleprompterShortcutManager()

    private var eventHandler: EventHandlerRef?
    private var hotKeyRef: EventHotKeyRef?

    private init() {}

    func registerShortcut() {
        guard TeleprompterDefaults.shared.globalShortcutEnabled else { return }

        let keyCode = parseKeyCode(TeleprompterDefaults.shared.globalShortcutKey)
        let modifiers = parseModifiers(TeleprompterDefaults.shared.globalShortcutKey)

        var hotKeyID = EventHotKeyID()
        hotKeyID.id = 1
        hotKeyID.signature = OSType("TPSC".fourCharCodeValue)

        var eventType = EventTypeSpec()
        eventType.eventClass = OSType(kEventClassKeyboard)
        eventType.eventKind = UInt32(kEventHotKeyPressed)

        InstallEventHandler(
            GetEventDispatcherTarget(),
            { (_, event, _) -> OSStatus in
                TeleprompterShortcutManager.shared.handleShortcutPress()
                return noErr
            },
            1,
            &eventType,
            nil,
            &TeleprompterShortcutManager.shared.eventHandler
        )

        RegisterEventHotKey(
            keyCode,
            modifiers,
            hotKeyID,
            GetEventDispatcherTarget(),
            0,
            &TeleprompterShortcutManager.shared.hotKeyRef
        )
    }

    func unregisterShortcut() {
        if let hotKeyRef = hotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
        }
        if let eventHandler = eventHandler {
            RemoveEventHandler(eventHandler)
        }
        hotKeyRef = nil
        eventHandler = nil
    }

    private func handleShortcutPress() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: NSNotification.Name("TeleprompterShortcutPressed"),
                object: nil
            )
        }
    }

    private func parseKeyCode(_ shortcut: String) -> UInt32 {
        let components = shortcut.lowercased().split(separator: "+")
        let key = components.last ?? ""

        switch key {
        case "t": return UInt32(kVK_ANSI_T)
        case "a": return UInt32(kVK_ANSI_A)
        case "b": return UInt32(kVK_ANSI_B)
        case "c": return UInt32(kVK_ANSI_C)
        case "d": return UInt32(kVK_ANSI_D)
        case "e": return UInt32(kVK_ANSI_E)
        case "f": return UInt32(kVK_ANSI_F)
        case "g": return UInt32(kVK_ANSI_G)
        case "h": return UInt32(kVK_ANSI_H)
        case "i": return UInt32(kVK_ANSI_I)
        case "j": return UInt32(kVK_ANSI_J)
        case "k": return UInt32(kVK_ANSI_K)
        case "l": return UInt32(kVK_ANSI_L)
        case "m": return UInt32(kVK_ANSI_M)
        case "n": return UInt32(kVK_ANSI_N)
        case "o": return UInt32(kVK_ANSI_O)
        case "p": return UInt32(kVK_ANSI_P)
        case "q": return UInt32(kVK_ANSI_Q)
        case "r": return UInt32(kVK_ANSI_R)
        case "s": return UInt32(kVK_ANSI_S)
        case "u": return UInt32(kVK_ANSI_U)
        case "v": return UInt32(kVK_ANSI_V)
        case "w": return UInt32(kVK_ANSI_W)
        case "x": return UInt32(kVK_ANSI_X)
        case "y": return UInt32(kVK_ANSI_Y)
        case "z": return UInt32(kVK_ANSI_Z)
        case "0": return UInt32(kVK_ANSI_0)
        case "1": return UInt32(kVK_ANSI_1)
        case "2": return UInt32(kVK_ANSI_2)
        case "3": return UInt32(kVK_ANSI_3)
        case "4": return UInt32(kVK_ANSI_4)
        case "5": return UInt32(kVK_ANSI_5)
        case "6": return UInt32(kVK_ANSI_6)
        case "7": return UInt32(kVK_ANSI_7)
        case "8": return UInt32(kVK_ANSI_8)
        case "9": return UInt32(kVK_ANSI_9)
        case "space": return UInt32(kVK_Space)
        case "return": return UInt32(kVK_Return)
        case "escape": return UInt32(kVK_Escape)
        default: return UInt32(kVK_ANSI_T)
        }
    }

    private func parseModifiers(_ shortcut: String) -> UInt32 {
        let components = shortcut.lowercased().split(separator: "+")
        var modifiers: UInt32 = 0

        for component in components.dropLast() {
            switch component {
            case "cmd", "command":
                modifiers |= UInt32(cmdKey)
            case "shift":
                modifiers |= UInt32(shiftKey)
            case "option", "alt":
                modifiers |= UInt32(optionKey)
            case "ctrl", "control":
                modifiers |= UInt32(controlKey)
            default: break
            }
        }

        return modifiers
    }
}

extension String {
    var fourCharCodeValue: FourCharCode {
        var result: FourCharCode = 0
        for char in self.utf16 {
            result = (result << 8) + FourCharCode(char)
        }
        return result
    }
}