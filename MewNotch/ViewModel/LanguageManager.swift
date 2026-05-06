//
//  LanguageManager.swift
//  MewNotch
//
//  Created by Claude on 07/05/26.
//

import SwiftUI

class LanguageManager: ObservableObject {

    static let shared = LanguageManager()

    @Published var currentLocale: Locale

    private var languageDefaults = LanguageDefaults.shared

    private init() {
        currentLocale = languageDefaults.currentLocale
    }

    func updateLocale(languageCode: String) {
        languageDefaults.languageCode = languageCode
        currentLocale = Locale(identifier: languageCode)
    }
}