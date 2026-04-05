//
//  LanguageSettingsView.swift
//  MewNotch
//
//  Created for internationalization support
//

import SwiftUI

struct LanguageSettingsView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject private var languageManager = LanguageManager.shared
    @State private var selectedLanguage: AppLanguage

    init() {
        _selectedLanguage = State(initialValue: LanguageManager.shared.currentLanguage)
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("settings.language".localized)
                .font(.headline)

            VStack(spacing: 8) {
                ForEach(AppLanguage.allCases) { language in
                    LanguageOptionButton(
                        language: language,
                        isSelected: selectedLanguage == language,
                        action: {
                            selectedLanguage = language
                            languageManager.currentLanguage = language
                        }
                    )
                }
            }

            HStack {
                Button("common.cancel".localized) {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)

                Button("common.save".localized) {
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(20)
        .frame(width: 300)
    }
}

struct LanguageOptionButton: View {
    let language: AppLanguage
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(language.displayName)
                    .font(.subheadline)
                    .foregroundColor(.primary)

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .blue : .gray)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LanguageSettingsView()
}
