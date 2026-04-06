//
//  SystemMonitorDefaults.swift
//  MewNotch
//
//  Settings storage for System Monitor feature
//

import SwiftUI

class SystemMonitorDefaults: ObservableObject {

    static let shared = SystemMonitorDefaults()

    private static var PREFIX: String = "Expanded_SystemMonitor_"

    private init() {}

    // MARK: - Display Settings

    @AppStorage(PREFIX + "showCpu")
    var showCpu: Bool = true {
        didSet {
            objectWillChange.send()
        }
    }

    @AppStorage(PREFIX + "showMemory")
    var showMemory: Bool = true {
        didSet {
            objectWillChange.send()
        }
    }

    @AppStorage(PREFIX + "showNetwork")
    var showNetwork: Bool = true {
        didSet {
            objectWillChange.send()
        }
    }

    // MARK: - Refresh

    @AppStorage(PREFIX + "refreshInterval")
    var refreshInterval: Double = 2.0 {
        didSet {
            objectWillChange.send()
        }
    }

    // MARK: - Collapsed Notch

    @AppStorage(PREFIX + "showInNotch")
    var showInNotch: Bool = false {
        didSet {
            objectWillChange.send()
        }
    }
}
