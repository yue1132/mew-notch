//
//  TeleprompterDefaults.swift
//  MewNotch
//

import Foundation

class TeleprompterDefaults: ObservableObject {

    static let shared = TeleprompterDefaults()

    private static var PREFIX = "Teleprompter_"

    private init() {}

    @CodableUserDefault(PREFIX + "Scripts", defaultValue: [])
    var scripts: [TeleprompterScriptModel] {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "CurrentScriptId", defaultValue: nil)
    var currentScriptId: UUID? {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "ScrollSpeed", defaultValue: 2.0)
    var scrollSpeed: Double {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "FontSize", defaultValue: 24.0)
    var fontSize: Double {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "ShowMirrorOverlay", defaultValue: false)
    var showMirrorOverlay: Bool {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "GlobalShortcutEnabled", defaultValue: true)
    var globalShortcutEnabled: Bool {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "GlobalShortcutKey", defaultValue: "cmd+shift+t")
    var globalShortcutKey: String {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "TextAlignment", defaultValue: "left")
    var textAlignment: String {
        didSet { self.objectWillChange.send() }
    }

    @PrimitiveUserDefault(PREFIX + "MirrorOverlayOpacity", defaultValue: 0.3)
    var mirrorOverlayOpacity: Double {
        didSet { self.objectWillChange.send() }
    }

    var currentScript: TeleprompterScriptModel? {
        guard let id = currentScriptId else { return scripts.first }
        return scripts.first { $0.id == id }
    }
}