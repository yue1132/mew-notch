//
//  TeleprompterViewModel.swift
//  MewNotch
//

import SwiftUI

class TeleprompterViewModel: ObservableObject {

    static let shared = TeleprompterViewModel()

    @Published var isScrolling: Bool = false
    @Published var scrollOffset: CGFloat = 0
    @Published var currentText: String = ""
    @Published var importedFileName: String?

    private var scrollTimer: Timer?

    let defaults = TeleprompterDefaults.shared

    private init() {
        loadCurrentScript()
        listenForShortcut()
    }

    private func loadCurrentScript() {
        if let script = defaults.currentScript {
            currentText = script.content
        }
    }

    private func listenForShortcut() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleShortcutPress),
            name: NSNotification.Name("TeleprompterShortcutPressed"),
            object: nil
        )
    }

    @objc func handleShortcutPress() {
        NotificationCenter.default.post(
            name: NSNotification.Name("ToggleTeleprompter"),
            object: nil
        )
    }

    func startScrolling() {
        guard !isScrolling, !currentText.isEmpty else { return }

        isScrolling = true
        scrollTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            self.tickScroll()
        }
    }

    func stopScrolling() {
        isScrolling = false
        scrollTimer?.invalidate()
        scrollTimer = nil
    }

    func resetScroll() {
        stopScrolling()
        scrollOffset = 0
    }

    private func tickScroll() {
        let speed = defaults.scrollSpeed
        scrollOffset += speed

        if NotchDefaults.shared.hapticFeedback {
            HapticsManager.shared.feedback(pattern: .generic)
        }
    }

    func manualScroll(delta: CGFloat) {
        scrollOffset += delta
    }

    func importTextFromFile(_ url: URL) {
        guard url.isFileURL else { return }

        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            currentText = content
            importedFileName = url.lastPathComponent

            // Save as new script
            let script = TeleprompterScriptModel(title: url.lastPathComponent, content: content)
            defaults.scripts.append(script)
            defaults.currentScriptId = script.id
        } catch {
            print("[DEBUG] TeleprompterViewModel.importTextFromFile: \(error)")
        }
    }

    func pasteFromClipboard() {
        if let content = NSPasteboard.general.string(forType: .string) {
            currentText = content
            importedFileName = "Clipboard"

            // Save as new script
            let script = TeleprompterScriptModel(title: "Clipboard Text", content: content)
            defaults.scripts.append(script)
            defaults.currentScriptId = script.id
        }
    }

    func saveCurrentText() {
        if let scriptId = defaults.currentScriptId {
            if let index = defaults.scripts.firstIndex(where: { $0.id == scriptId }) {
                defaults.scripts[index].updateContent(currentText)
            }
        } else {
            let script = TeleprompterScriptModel(title: "Untitled", content: currentText)
            defaults.scripts.append(script)
            defaults.currentScriptId = script.id
        }
    }

    func selectScript(_ script: TeleprompterScriptModel) {
        defaults.currentScriptId = script.id
        currentText = script.content
        importedFileName = script.title
        resetScroll()
    }

    func deleteScript(_ script: TeleprompterScriptModel) {
        defaults.scripts.removeAll { $0.id == script.id }
        if defaults.currentScriptId == script.id {
            defaults.currentScriptId = nil
            currentText = ""
            importedFileName = nil
        }
    }
}