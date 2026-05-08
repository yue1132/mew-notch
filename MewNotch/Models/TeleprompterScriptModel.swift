//
//  TeleprompterScriptModel.swift
//  MewNotch
//

import Foundation

struct TeleprompterScriptModel: Codable, Identifiable {
    let id: UUID
    var title: String
    var content: String
    var createdAt: Date
    var updatedAt: Date

    init(title: String, content: String) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.createdAt = Date()
        self.updatedAt = Date()
    }

    mutating func updateContent(_ newContent: String) {
        self.content = newContent
        self.updatedAt = Date()
    }

    mutating func updateTitle(_ newTitle: String) {
        self.title = newTitle
        self.updatedAt = Date()
    }
}