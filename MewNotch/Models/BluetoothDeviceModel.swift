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

    init(
        name: String,
        address: String? = nil,
        minorType: String? = nil,
        services: String? = nil
    ) {
        self.name = name
        self.address = address
        self.minorType = minorType
        self.services = services
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
}
