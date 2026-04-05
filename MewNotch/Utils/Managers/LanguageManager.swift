//
//  LanguageManager.swift
//  MewNotch
//
//  Created for internationalization support
//

import Foundation
import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case system = "system"
    case english = "en"
    case chineseSimplified = "zh-Hans"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .system:
            return "settings.language.system".localized
        case .english:
            return "English"
        case .chineseSimplified:
            return "简体中文"
        }
    }

    var localeIdentifier: String? {
        switch self {
        case .system:
            return nil
        case .english:
            return "en"
        case .chineseSimplified:
            return "zh-Hans"
        }
    }
}

class LanguageManager: ObservableObject {

    static let shared = LanguageManager()

    private static let languageKey = "app_language"

    @Published var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: Self.languageKey)
            currentBundle = Self.resolveBundle(for: currentLanguage)
        }
    }

    @Published private(set) var currentBundle: Bundle

    private init() {
        let language: AppLanguage
        if let savedValue = UserDefaults.standard.string(forKey: Self.languageKey),
           let saved = AppLanguage(rawValue: savedValue) {
            language = saved
        } else {
            language = .system
        }
        self.currentLanguage = language
        self.currentBundle = Self.resolveBundle(for: language)
    }

    // MARK: - Bundle Resolution

    private static func resolveBundle(for language: AppLanguage) -> Bundle {
        // Determine the target locale identifier
        let localeId: String?
        if let id = language.localeIdentifier {
            localeId = id
        } else {
            // System default: use the user's first preferred language
            localeId = Locale.preferredLanguages.first
        }

        guard let localeId = localeId else {
            return Bundle.main
        }

        // 1) Try exact match (e.g. "zh-Hans", "en")
        if let bundle = loadBundle(for: localeId) {
            return bundle
        }

        // 2) Try just the language code prefix (e.g. "en" from "en-US")
        let shortCode = localeId.components(separatedBy: "-").first ?? localeId
        if shortCode != localeId, let bundle = loadBundle(for: shortCode) {
            return bundle
        }

        // 3) Special case: any Chinese variant -> zh-Hans
        if shortCode == "zh", let bundle = loadBundle(for: "zh-Hans") {
            return bundle
        }

        // 4) Fallback to main bundle
        return Bundle.main
    }

    private static func loadBundle(for localeId: String) -> Bundle? {
        guard let path = Bundle.main.path(forResource: localeId, ofType: "lproj") else {
            return nil
        }
        return Bundle(path: path)
    }
}

// MARK: - View Refresh Helper

extension View {
    /// Tracks LanguageManager so the view re-renders when language changes.
    /// Apply this to root views (settings window, menu bar content).
    func liveLocalized() -> some View {
        self.onReceive(LanguageManager.shared.$currentLanguage) { _ in }
    }
}

// MARK: - String Localization Extension

extension String {
    var localized: String {
        return LanguageManager.shared.currentBundle
            .localizedString(forKey: self, value: nil, table: nil)
    }

    func localized(with arguments: CVarArg...) -> String {
        let format = LanguageManager.shared.currentBundle
            .localizedString(forKey: self, value: nil, table: nil)
        return String(format: format, arguments: arguments)
    }
}
