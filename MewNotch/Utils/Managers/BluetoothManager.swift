//
//  BluetoothManager.swift
//  MewNotch
//
//  Created for Bluetooth feature expansion
//

import Foundation
import SwiftUI

class BluetoothManager: ObservableObject {

    static let shared = BluetoothManager()

    @Published var connectedAudioDevices: [BluetoothDeviceModel] = []
    @Published var isRefreshing: Bool = false

    private var refreshTimer: Timer?
    private let bluetoothDefaults = BluetoothDefaults.shared

    private init() {
        NSLog("[BT] BluetoothManager init")
        refreshDevices()
        startMonitoring()
    }

    deinit {
        stopMonitoring()
    }

    // MARK: - Monitoring

    func startMonitoring() {
        stopMonitoring()
        let interval = bluetoothDefaults.refreshInterval
        refreshTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.refreshDevices()
        }
    }

    func stopMonitoring() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }

    // MARK: - Device Refresh

    func refreshDevices() {
        DispatchQueue.main.async {
            self.isRefreshing = true
        }

        DispatchQueue.global(qos: .userInitiated).async {
            let devices = self.fetchConnectedAudioDevices()

            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.connectedAudioDevices = devices
                    self.isRefreshing = false
                }
                NSLog("[BT] Found %d audio device(s)", devices.count)
            }
        }
    }

    // MARK: - Data Fetching

    private func fetchConnectedAudioDevices() -> [BluetoothDeviceModel] {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/sbin/system_profiler")
        task.arguments = ["SPBluetoothDataType", "-json"]

        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = FileHandle.nullDevice

        do {
            try task.run()
            task.waitUntilExit()

            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let outputStr = String(data: data, encoding: .utf8) ?? ""
            NSLog("[BT] system_profiler (%d bytes): %@", data.count, String(outputStr.prefix(300)))
            return parseJSON(data)
        } catch {
            NSLog("[BT] Error: %@", error.localizedDescription)
            return []
        }
    }

    // MARK: - JSON Parsing

    private func parseJSON(_ data: Data) -> [BluetoothDeviceModel] {
        guard !data.isEmpty else {
            NSLog("[BT] parseJSON: empty data")
            return []
        }

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let spArray = json["SPBluetoothDataType"] as? [[String: Any]] else {
            NSLog("[BT] parseJSON: failed to parse top-level JSON")
            return []
        }

        var devices: [BluetoothDeviceModel] = []

        for spItem in spArray {
            if let connected = spItem["device_connected"] as? [[String: Any]] {
                for deviceEntry in connected {
                    for (deviceName, props) in deviceEntry {
                        guard let properties = props as? [String: Any] else { continue }

                        NSLog("[BT] Device: '%@' minorType=%@ services=%@", deviceName, properties["device_minorType"] as? String ?? "nil", properties["device_services"] as? String ?? "nil")

                        if isAudioDevice(properties) {
                            let batteryMain = parseBattery(properties["device_batteryLevelMain"] as? String)
                            let batteryCase = parseBattery(properties["device_batteryLevelCase"] as? String)

                            let model = BluetoothDeviceModel(
                                name: deviceName,
                                address: properties["device_address"] as? String,
                                minorType: properties["device_minorType"] as? String,
                                services: properties["device_services"] as? String,
                                batteryLevelMain: batteryMain,
                                batteryLevelCase: batteryCase
                            )
                            devices.append(model)
                        }
                    }
                }
            }
        }

        return devices
    }

    private func isAudioDevice(_ properties: [String: Any]) -> Bool {
        let audioMinorTypes: Set<String> = ["Headset", "Headphones", "Speaker"]

        if let minorType = properties["device_minorType"] as? String,
           audioMinorTypes.contains(minorType) {
            return true
        }

        if let services = properties["device_services"] as? String {
            if services.contains("A2DP") || services.contains("HFP") {
                return true
            }
        }

        return false
    }

    private func parseBattery(_ value: String?) -> Int? {
        guard let value = value else { return nil }
        // system_profiler returns battery as "75%" or just "75"
        let digits = value.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        guard let level = Int(digits), level >= 0, level <= 100 else { return nil }
        return level
    }
}
