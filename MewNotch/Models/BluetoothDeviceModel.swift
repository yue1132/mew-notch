//
//  BluetoothDeviceModel.swift
//  MewNotch
//
//  Created for Bluetooth feature expansion
//

import Foundation

struct BluetoothDeviceModel: Identifiable {

    let id = UUID()

    let name: String
    let address: String?
    let minorType: String?
    let services: String?
    let batteryLevelMain: Int?
    let batteryLevelCase: Int?

    init(
        name: String,
        address: String? = nil,
        minorType: String? = nil,
        services: String? = nil,
        batteryLevelMain: Int? = nil,
        batteryLevelCase: Int? = nil
    ) {
        self.name = name
        self.address = address
        self.minorType = minorType
        self.services = services
        self.batteryLevelMain = batteryLevelMain
        self.batteryLevelCase = batteryLevelCase
    }

    /// SF Symbol name based on device type
    var iconName: String {
        guard let type = minorType?.lowercased() else {
            return "bluetooth"
        }
        if type.contains("headphone") {
            return "headphones"
        } else if type.contains("headset") {
            return "headset"
        } else if type.contains("speaker") {
            return "speaker.wave.2.fill"
        }
        return "bluetooth"
    }

    var batteryIcon: String {
        guard let level = batteryLevelMain else { return "battery.0" }
        if level >= 90 { return "battery.100" }
        if level >= 60 { return "battery.75" }
        if level >= 30 { return "battery.50" }
        return "battery.25"
    }

    var batteryColor: String {
        guard let level = batteryLevelMain else { return "gray" }
        if level >= 50 { return "green" }
        if level >= 20 { return "orange" }
        return "red"
    }

    var hasBattery: Bool { batteryLevelMain != nil }
}
