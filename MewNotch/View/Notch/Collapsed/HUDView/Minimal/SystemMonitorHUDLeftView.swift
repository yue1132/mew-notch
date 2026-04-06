//
//  SystemMonitorHUDLeftView.swift
//  MewNotch
//
//  Collapsed notch - CPU percentage (left side)
//

import SwiftUI

struct SystemMonitorHUDLeftView: View {

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
                        .frame(width: 6)
                    Text("C")
                        .font(.system(size: 9, weight: .medium, design: .monospaced))
                        .foregroundColor(cpuColor)
                    Text("\(Int(round(monitor.cpuUsage)))%")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .monospacedDigit()
                        .foregroundColor(.white)
                    Spacer()
                        .frame(width: 4)
                }
                .fixedSize()
                .padding(.vertical, 3)
                .background(
                    Capsule()
                        .fill(Color.black.opacity(0.75))
                )
            }
            .buttonStyle(.plain)
            .transition(.move(edge: .trailing).combined(with: .opacity))
        }
    }

    private var cpuColor: Color {
        if monitor.cpuUsage >= 80 { return .red }
        if monitor.cpuUsage >= 60 { return .orange }
        return .blue
    }
}
