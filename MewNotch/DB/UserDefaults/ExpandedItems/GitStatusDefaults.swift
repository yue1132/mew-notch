//
//  GitStatusDefaults.swift
//  MewNotch
//
//  Improved with intelligent repository discovery settings
//

import SwiftUI

class GitStatusDefaults: ObservableObject {

    static let shared = GitStatusDefaults()

    private static var PREFIX: String = "Expanded_GitStatus_"

    private init() {}

    // MARK: - Repository Discovery

    /// Paths to scan for repositories (comma-separated, supports ~ notation)
    @AppStorage(PREFIX + "scanPathsRaw")
    private var scanPathsRaw: String = "~/study,~/workspaces"

    var scanPaths: [String] {
        get {
            scanPathsRaw.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
        }
        set {
            scanPathsRaw = newValue.joined(separator: ",")
            objectWillChange.send()
        }
    }

    /// Maximum depth to scan for repositories
    @AppStorage(PREFIX + "scanDepth")
    var scanDepth: Int = 2 {
        didSet {
            objectWillChange.send()
        }
    }

    /// Maximum number of repositories to display
    @AppStorage(PREFIX + "maxRepositoriesToShow")
    var maxRepositoriesToShow: Int = 3 {
        didSet {
            objectWillChange.send()
        }
    }

    /// Only show repos with activity within this number of days
    @AppStorage(PREFIX + "activityThresholdDays")
    var activityThresholdDays: Double = 7.0 {
        didSet {
            objectWillChange.send()
        }
    }

    // MARK: - Display Settings

    @AppStorage(PREFIX + "isEnabled")
    var isEnabled: Bool = true {
        didSet {
            objectWillChange.send()
        }
    }

    @AppStorage(PREFIX + "showCIStatus")
    var showCIStatus: Bool = false {
        didSet {
            objectWillChange.send()
        }
    }

    @AppStorage(PREFIX + "showUncommittedCount")
    var showUncommittedCount: Bool = true {
        didSet {
            objectWillChange.send()
        }
    }

    @AppStorage(PREFIX + "refreshInterval")
    var refreshInterval: Double = 30.0 {
        didSet {
            objectWillChange.send()
        }
    }

    // MARK: - Notifications

    @AppStorage(PREFIX + "showNotificationsOnCIFail")
    var showNotificationsOnCIFail: Bool = false {
        didSet {
            objectWillChange.send()
        }
    }
}