//
//  BluetoothDefaults.swift
//  MewNotch
//
//  Created for Bluetooth feature expansion
//

import SwiftUI

class BluetoothDefaults: ObservableObject {

    static let shared = BluetoothDefaults()

    private static var PREFIX: String = "Expanded_Bluetooth_"

    private init() {}

    @AppStorage(PREFIX + "isEnabled")
    var isEnabled: Bool = true {
        didSet {
            withAnimation {
                self.objectWillChange.send()
            }
        }
    }

    @AppStorage(PREFIX + "showConnectionNotifications")
    var showConnectionNotifications: Bool = false {
        didSet {
            withAnimation {
                self.objectWillChange.send()
            }
        }
    }

    @AppStorage(PREFIX + "refreshInterval")
    var refreshInterval: Double = 5.0 {
        didSet {
            withAnimation {
                self.objectWillChange.send()
            }
        }
    }
}
