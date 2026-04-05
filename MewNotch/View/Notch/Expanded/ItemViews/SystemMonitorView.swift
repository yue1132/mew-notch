//
//  SystemMonitorView.swift
//  MewNotch
//
//  System Monitor - Compact Layout
//

import SwiftUI

struct SystemMonitorView: View {

    @ObservedObject var notchViewModel: NotchViewModel
    @StateObject private var monitor = SystemMonitorManager.shared
    @StateObject private var defaults = SystemMonitorDefaults.shared

    var body: some View {
        VStack(spacing: 6) {
            if defaults.showCpu { cpuRow }
            if defaults.showMemory { memRow }
            if defaults.showNetwork { netRow }
        }
        .padding(8)
        .frame(width: notchViewModel.notchSize.width)
        .onAppear { monitor.refresh() }
    }

    private var cpuRow: some View {
        row(
            icon: "cpu",
            iconColor: .blue,
            label: "CPU",
            value: String(format: "%.0f%%", monitor.cpuUsage),
            percent: monitor.cpuUsage
        )
    }

    private var memRow: some View {
        row(
            icon: "memorychip",
            iconColor: .purple,
            label: "MEM",
            value: monitor.formatMemory(monitor.memoryUsed),
            percent: monitor.memoryPercentage
        )
    }

    private var netRow: some View {
        HStack(spacing: 10) {
            netStat(icon: "arrow.down", color: .green, value: monitor.formatSpeed(monitor.networkDownloadSpeed))
            netStat(icon: "arrow.up", color: .orange, value: monitor.formatSpeed(monitor.networkUploadSpeed))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(RoundedRectangle(cornerRadius: 6).fill(Color.white.opacity(0.05)))
    }

    private func row(icon: String, iconColor: Color, label: String, value: String, percent: Double) -> some View {
        VStack(spacing: 3) {
            HStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 11)).foregroundColor(iconColor).frame(width: 16)
                Text(label).font(.system(size: 8)).foregroundColor(.gray).frame(width: 28, alignment: .leading)
                Spacer()
                Text(value).font(.system(size: 10, weight: .semibold)).foregroundColor(.white)
                Text(String(format: "%.0f%%", percent))
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(pColor(percent))
                    .frame(width: 32, alignment: .trailing)
            }
            GeometryReader { g in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2).fill(Color.gray.opacity(0.3))
                    RoundedRectangle(cornerRadius: 2).fill(iconColor).frame(width: g.size.width * min(percent / 100, 1))
                }
            }.frame(height: 4)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(RoundedRectangle(cornerRadius: 6).fill(Color.white.opacity(0.05)))
    }

    private func netStat(icon: String, color: Color, value: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon).font(.system(size: 9)).foregroundColor(color)
            Text(value).font(.system(size: 9, weight: .medium)).foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
    }

    private func pColor(_ p: Double) -> Color {
        if p >= 80 { return .red }
        if p >= 60 { return .orange }
        return .green
    }
}

#Preview {
    if let screen = NSScreen.main {
        SystemMonitorView(notchViewModel: NotchViewModel(screen: screen))
    }
}