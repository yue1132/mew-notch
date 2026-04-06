//
//  BluetoothView.swift
//  MewNotch
//
//  Bluetooth devices with battery levels
//

import SwiftUI

struct BluetoothView: View {

    @ObservedObject var notchViewModel: NotchViewModel
    @ObservedObject private var bluetoothManager = BluetoothManager.shared

    var body: some View {
        VStack(spacing: 8) {
            if bluetoothManager.connectedAudioDevices.isEmpty {
                emptyStateView
            } else {
                devicesListView
            }
        }
        .padding(8)
        .frame(
            width: notchViewModel.notchSize.width,
            height: notchViewModel.notchSize.height * 3
        )
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.3))
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var emptyStateView: some View {
        VStack(spacing: 6) {
            Spacer()

            Image(systemName: "bluetooth")
                .font(.system(size: 22))
                .foregroundColor(.gray)

            Text("bluetooth.noDevices".localized)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.gray)

            Text("bluetooth.connectDevice".localized)
                .font(.system(size: 8))
                .foregroundColor(.gray.opacity(0.5))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)

            Spacer()
        }
    }

    private var devicesListView: some View {
        VStack(spacing: 6) {
            ForEach(bluetoothManager.connectedAudioDevices) { device in
                HStack(spacing: 8) {
                    Image(systemName: device.iconName)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .frame(width: 22)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(device.name)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)

                        if let type = device.minorType {
                            Text(type)
                                .font(.system(size: 8))
                                .foregroundColor(.gray.opacity(0.6))
                        }
                    }

                    Spacer()

                    // Battery indicator
                    if device.hasBattery {
                        batteryView(device: device)
                    } else {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 6, height: 6)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.08))
                )
            }
        }
    }

    private func batteryView(device: BluetoothDeviceModel) -> some View {
        HStack(spacing: 3) {
            Image(systemName: device.batteryIcon)
                .font(.system(size: 11))
                .foregroundColor(batteryTintColor(device.batteryLevelMain))

            if let level = device.batteryLevelMain {
                Text("\(level)%")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(batteryTintColor(level))
            }
        }
    }

    private func batteryTintColor(_ level: Int?) -> Color {
        guard let level = level else { return .gray }
        if level >= 50 { return .green }
        if level >= 20 { return .orange }
        return .red
    }
}

#Preview {
    if let screen = NSScreen.main {
        BluetoothView(notchViewModel: NotchViewModel(screen: screen))
    }
}
