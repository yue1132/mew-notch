//
//  GitStatusManager.swift
//  MewNotch
//
//  Improved with intelligent active repository detection
//

import Foundation
import SwiftUI

class GitStatusManager: ObservableObject {

    static let shared = GitStatusManager()

    @Published var activeRepositories: [GitStatusModel] = []
    @Published var isRefreshing: Bool = false
    @Published var lastError: String?

    private var refreshTimer: Timer?
    private let gitDefaults = GitStatusDefaults.shared

    // Directories to scan for git repositories
    private let defaultScanPaths = [
        "~/study",
        "~/workspaces"
    ]

    private init() {
        startMonitoring()
    }

    deinit {
        stopMonitoring()
    }

    // MARK: - Monitoring

    func startMonitoring() {
        stopMonitoring()

        let interval = gitDefaults.refreshInterval
        refreshTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            Task {
                await self?.refreshStatus()
            }
        }

        // Initial refresh
        Task {
            await self.refreshStatus()
        }
    }

    func stopMonitoring() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }

    // MARK: - Status Refresh

    func refreshStatus() async {
        await MainActor.run {
            self.isRefreshing = true
            self.lastError = nil
        }

        do {
            // Find all git repositories
            let allRepos = await discoverRepositories()

            // Get activity info for each repo and sort by most recent
            let activeRepos = await getActiveRepositories(from: allRepos)

            // Fetch status for top N active repos
            let maxRepos = gitDefaults.maxRepositoriesToShow
            var statuses: [GitStatusModel] = []

            for repoPath in activeRepos.prefix(maxRepos) {
                if let status = try? await fetchGitStatus(repoPath: repoPath) {
                    statuses.append(status)
                }
            }

            await MainActor.run {
                withAnimation {
                    self.activeRepositories = statuses
                    self.isRefreshing = false
                }
            }
        } catch {
            await MainActor.run {
                withAnimation {
                    self.lastError = error.localizedDescription
                    self.isRefreshing = false
                }
            }
        }
    }

    // MARK: - Repository Discovery

    private func discoverRepositories() async -> [String] {
        var repositories: [String] = []

        // Use configured paths or defaults
        let scanPaths = gitDefaults.scanPaths.isEmpty
            ? defaultScanPaths
            : gitDefaults.scanPaths

        for pathPattern in scanPaths {
            let expandedPath = expandPath(pathPattern)
            let repos = await findGitRepositories(in: expandedPath, maxDepth: gitDefaults.scanDepth)
            repositories.append(contentsOf: repos)
        }

        return repositories
    }

    private func expandPath(_ path: String) -> String {
        if path.hasPrefix("~") {
            return (path as NSString).expandingTildeInPath
        }
        return path
    }

    private func findGitRepositories(in basePath: String, maxDepth: Int) async -> [String] {
        var repositories: [String] = []

        let fileManager = FileManager.default

        // Check if base path exists
        guard fileManager.fileExists(atPath: basePath) else {
            return repositories
        }

        // Iterate through directory structure
        var directoriesToCheck = [basePath]
        var currentDepth = 0

        while !directoriesToCheck.isEmpty && currentDepth <= maxDepth {
            var nextLevelDirectories: [String] = []

            for directory in directoriesToCheck {
                guard let contents = try? fileManager.contentsOfDirectory(atPath: directory) else {
                    continue
                }

                for item in contents {
                    // Skip hidden directories (except .git)
                    if item.hasPrefix(".") && item != ".git" {
                        continue
                    }

                    let fullPath = (directory as NSString).appendingPathComponent(item)

                    // Check if this is a git repository
                    let gitPath = (fullPath as NSString).appendingPathComponent(".git")
                    if fileManager.fileExists(atPath: gitPath) {
                        repositories.append(fullPath)
                    } else if isDirectory(atPath: fullPath) {
                        // Add to next level for further scanning
                        nextLevelDirectories.append(fullPath)
                    }
                }
            }

            directoriesToCheck = nextLevelDirectories
            currentDepth += 1
        }

        return repositories
    }

    // MARK: - Activity Detection

    private func getActiveRepositories(from allRepos: [String]) async -> [String] {
        // Get last activity time for each repository
        var repoActivities: [(path: String, lastActivity: Date)] = []

        for repoPath in allRepos {
            if let lastActivity = await getLastActivityTime(repoPath: repoPath) {
                repoActivities.append((repoPath, lastActivity))
            }
        }

        // Sort by most recent activity (descending)
        repoActivities.sort { $0.lastActivity > $1.lastActivity }

        // Filter by minimum activity threshold (e.g., active within last 7 days)
        let threshold = gitDefaults.activityThresholdDays
        let now = Date()
        let activeThreshold = now.addingTimeInterval(-threshold * 24 * 60 * 60)

        let activeRepos = repoActivities
            .filter { $0.lastActivity >= activeThreshold }
            .map { $0.path }

        // If no active repos within threshold, return top 3 most recent anyway
        if activeRepos.isEmpty && repoActivities.count >= 3 {
            return repoActivities.prefix(3).map { $0.path }
        }

        return activeRepos.isEmpty ? Array(allRepos.prefix(3)) : activeRepos
    }

    private func getLastActivityTime(repoPath: String) async -> Date? {
        let fileManager = FileManager.default
        let gitPath = (repoPath as NSString).appendingPathComponent(".git")

        // Check multiple indicators of git activity
        var latestActivity: Date? = nil

        // 1. Check FETCH_HEAD (last fetch time)
        let fetchHeadPath = (gitPath as NSString).appendingPathComponent("FETCH_HEAD")
        if let fetchDate = getFileModificationDate(fetchHeadPath) {
            latestActivity = maxActivityDate(latestActivity, fetchDate)
        }

        // 2. Check ORIG_HEAD (last rebase/merge/reset)
        let origHeadPath = (gitPath as NSString).appendingPathComponent("ORIG_HEAD")
        if let origDate = getFileModificationDate(origHeadPath) {
            latestActivity = maxActivityDate(latestActivity, origDate)
        }

        // 3. Check logs directory (reflog entries)
        let logsPath = (gitPath as NSString).appendingPathComponent("logs")
        if let logsContents = try? fileManager.contentsOfDirectory(atPath: logsPath) {
            for logFile in logsContents {
                let logFilePath = (logsPath as NSString).appendingPathComponent(logFile)
                if let logDate = getFileModificationDate(logFilePath) {
                    latestActivity = maxActivityDate(latestActivity, logDate)
                }
            }
        }

        // 4. Check HEAD (current branch switch)
        let headPath = (gitPath as NSString).appendingPathComponent("HEAD")
        if let headDate = getFileModificationDate(headPath) {
            latestActivity = maxActivityDate(latestActivity, headDate)
        }

        // 5. Check index (staging area - indicates local changes)
        let indexPath = (gitPath as NSString).appendingPathComponent("index")
        if let indexDate = getFileModificationDate(indexPath) {
            latestActivity = maxActivityDate(latestActivity, indexDate)
        }

        return latestActivity
    }

    private func getFileModificationDate(_ path: String) -> Date? {
        let fileManager = FileManager.default
        guard let attributes = try? fileManager.attributesOfItem(atPath: path),
              let modDate = attributes[.modificationDate] as? Date else {
            return nil
        }
        return modDate
    }

    private func maxActivityDate(_ current: Date?, _ new: Date) -> Date? {
        if let current = current {
            return max(current, new)
        }
        return new
    }

    private func isDirectory(atPath path: String) -> Bool {
        var isDir: ObjCBool = false
        return FileManager.default.fileExists(atPath: path, isDirectory: &isDir) && isDir.boolValue
    }

    // MARK: - Git Status Fetching

    private func fetchGitStatus(repoPath: String) async throws -> GitStatusModel {
        // Get current branch
        let branch = try await runGitCommand(args: ["branch", "--show-current"], at: repoPath)
            .trimmingCharacters(in: .whitespacesAndNewlines)

        // Get repository name
        let remoteUrl = try? await runGitCommand(args: ["config", "--get", "remote.origin.url"], at: repoPath)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let repoName = (remoteUrl.flatMap { URL(string: $0)?.deletingPathExtension().lastPathComponent }) ?? ""

        // Get uncommitted files count
        let statusOutput = try await runGitCommand(args: ["status", "--porcelain"], at: repoPath)
        let uncommittedFiles = statusOutput
            .split(separator: "\n", omittingEmptySubsequences: true)
            .count

        // Get ahead/behind counts
        let aheadBehind = try await runGitCommand(
            args: ["rev-list", "--left-right", "--count", "@{upstream}...HEAD"],
            at: repoPath
        ).trimmingCharacters(in: .whitespacesAndNewlines)
        let parts = aheadBehind.split(separator: "\t")
        let behind = parts.count > 0 ? Int(parts[0]) ?? 0 : 0
        let ahead = parts.count > 1 ? Int(parts[1]) ?? 0 : 0

        // Get last commit info
        let lastCommit = try await runGitCommand(
            args: ["log", "-1", "--format=%H|%s|%an|%ci"],
            at: repoPath
        ).trimmingCharacters(in: .whitespacesAndNewlines)
        let commitParts = lastCommit.split(separator: "|", maxSplits: 3)

        let commitHash = commitParts.count > 0 ? String(commitParts[0]) : nil
        let commitMessage = commitParts.count > 1 ? String(commitParts[1]) : nil
        let commitAuthor = commitParts.count > 2 ? String(commitParts[2]) : nil
        let commitDateStr = commitParts.count > 3 ? String(commitParts[3]) : nil

        let commitDate: Date? = {
            guard let dateStr = commitDateStr else { return nil }
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            return formatter.date(from: dateStr)
        }()

        return GitStatusModel(
            repoName: repoName.isEmpty ? (repoPath as NSString).lastPathComponent : repoName,
            repoPath: repoPath,
            currentBranch: branch,
            uncommittedFiles: uncommittedFiles,
            ahead: ahead,
            behind: behind,
            lastCommitHash: commitHash,
            lastCommitMessage: commitMessage,
            lastCommitAuthor: commitAuthor,
            lastCommitDate: commitDate
        )
    }

    private func runGitCommand(args: [String], at path: String) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
            process.arguments = args
            process.currentDirectoryURL = URL(fileURLWithPath: path)

            let pipe = Pipe()
            process.standardOutput = pipe
            process.standardError = Pipe()

            do {
                try process.run()
                process.waitUntilExit()

                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                let output = String(data: data, encoding: .utf8) ?? ""
                continuation.resume(returning: output)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}

enum GitError: LocalizedError {
    case noRepositoryFound
    case commandFailed(String)

    var errorDescription: String? {
        switch self {
        case .noRepositoryFound:
            return "No Git repository found"
        case .commandFailed(let message):
            return "Git command failed: \(message)"
        }
    }
}