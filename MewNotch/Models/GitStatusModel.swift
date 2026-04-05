//
//  GitStatusModel.swift
//  MewNotch
//
//  Model for Git repository status
//

import Foundation

struct GitStatusModel: Identifiable {
    let id = UUID()

    let repoName: String
    let repoPath: String
    let currentBranch: String
    let uncommittedFiles: Int
    let ahead: Int
    let behind: Int
    let lastCommitHash: String?
    let lastCommitMessage: String?
    let lastCommitAuthor: String?
    let lastCommitDate: Date?
    let refreshedAt: Date

    init(
        repoName: String = "",
        repoPath: String = "",
        currentBranch: String = "",
        uncommittedFiles: Int = 0,
        ahead: Int = 0,
        behind: Int = 0,
        lastCommitHash: String? = nil,
        lastCommitMessage: String? = nil,
        lastCommitAuthor: String? = nil,
        lastCommitDate: Date? = nil,
        refreshedAt: Date = Date()
    ) {
        self.repoName = repoName.isEmpty ? (repoPath as NSString).lastPathComponent : repoName
        self.repoPath = repoPath
        self.currentBranch = currentBranch
        self.uncommittedFiles = uncommittedFiles
        self.ahead = ahead
        self.behind = behind
        self.lastCommitHash = lastCommitHash
        self.lastCommitMessage = lastCommitMessage
        self.lastCommitAuthor = lastCommitAuthor
        self.lastCommitDate = lastCommitDate
        self.refreshedAt = refreshedAt
    }

    var hasUncommittedChanges: Bool {
        uncommittedFiles > 0
    }

    var needsSync: Bool {
        ahead > 0 || behind > 0
    }

    var shortCommitHash: String? {
        guard let hash = lastCommitHash, hash.count >= 7 else { return nil }
        return String(hash.prefix(7))
    }

    var relativeRefreshTime: String {
        let elapsed = Date().timeIntervalSince(refreshedAt)
        if elapsed < 60 {
            return "刚刚"
        } else if elapsed < 3600 {
            return "\(Int(elapsed / 60))分钟前"
        } else if elapsed < 86400 {
            return "\(Int(elapsed / 3600))小时前"
        } else {
            return "\(Int(elapsed / 86400))天前"
        }
    }
}