//
//  LanguageDefaults.swift
//  MewNotch
//
//  Created by Claude on 07/05/26.
//

import Foundation

class LanguageDefaults: ObservableObject {

    private static var PREFIX: String = "Language_"

    static let shared = LanguageDefaults()

    private init() {}

    @PrimitiveUserDefault(
        PREFIX + "LanguageCode",
        defaultValue: "en"
    )
    var languageCode: String {
        didSet {
            self.objectWillChange.send()
        }
    }

    var currentLocale: Locale {
        Locale(identifier: languageCode)
    }
}