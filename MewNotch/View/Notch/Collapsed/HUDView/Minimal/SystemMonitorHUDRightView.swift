//
//  SystemMonitorHUDRightView.swift
//  MewNotch
//
//  Collapsed notch - Memory percentage (right side)
//

import SwiftUI

struct SystemMonitorHUDRightView: View {

    @ObservedObject var notchViewModel: NotchViewModel
    @StateObject private var monitor = SystemMonitorManager.shared
    @StateObject private var defaults = SystemMonitorDefaults.shared

    var body: some View {
        if defaults.showInNotch {
            Button {
                NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.ActivityMonitor")!)
            } label: {
                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: 4)
                    Text("M")
                        .font(.system(size: 9, weight: .medium, design: .monospaced))
                        .foregroundColor(memColor)
                    Text("\(Int(round(monitor.memoryPercentage)))%")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .monospacedDigit()
                        .foregroundColor(.white)
                    Spacer()
                        .frame(width: 6)
                }
                .fixedSize()
                .padding(.vertical, 3)
                .background(
                    Capsule()
                        .fill(Color.black.opacity(0.75))
                )
            }
            .buttonStyle(.plain)
            .transition(.move(edge: .leading).combined(with: .opacity))
        }
    }

    private var memColor: Color {
        if monitor.memoryPercentage >= 90 { return .red }
        if monitor.memoryPercentage >= 70 { return .orange }
        return .purple
    }
}
