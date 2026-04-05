//
//  SystemMonitorManager.swift
//  MewNotch
//
//  Manager for system monitoring (CPU, Memory, Network)
//

import Foundation
import SwiftUI
import Darwin

class SystemMonitorManager: ObservableObject {

    static let shared = SystemMonitorManager()

    // Published values
    @Published var cpuUsage: Double = 0
    @Published var memoryUsed: UInt64 = 0
    @Published var memoryTotal: UInt64 = 0
    @Published var memoryPercentage: Double = 0
    @Published var networkDownloadSpeed: Double = 0
    @Published var networkUploadSpeed: Double = 0

    @Published var isRefreshing: Bool = false

    private var timer: Timer?
    private let defaults = SystemMonitorDefaults.shared

    // Previous values for delta calculations
    private var previousCpuTicks: (user: UInt64, system: UInt64, idle: UInt64, nice: UInt64) = (0, 0, 0, 0)
    private var previousDownload: UInt64 = 0
    private var previousUpload: UInt64 = 0
    private var previousTime: Date = Date()

    private init() {
        startMonitoring()
    }

    deinit {
        stopMonitoring()
    }

    // MARK: - Monitoring

    func startMonitoring() {
        stopMonitoring()

        let interval = defaults.refreshInterval
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.refresh()
        }

        refresh()
    }

    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Refresh

    func refresh() {
        DispatchQueue.main.async {
            self.isRefreshing = true
        }

        DispatchQueue.global(qos: .utility).async {
            var cpu: Double = 0
            var memUsed: UInt64 = 0
            var memTotal: UInt64 = 0
            var downloadSpeed: Double = 0
            var uploadSpeed: Double = 0

            // CPU
            if self.defaults.showCpu {
                cpu = self.getCPUUsage()
            }

            // Memory
            if self.defaults.showMemory {
                (memUsed, memTotal) = self.getMemoryUsage()
            }

            // Network
            if self.defaults.showNetwork {
                (downloadSpeed, uploadSpeed) = self.getNetworkSpeed()
            }

            DispatchQueue.main.async {
                self.cpuUsage = cpu
                self.memoryUsed = memUsed
                self.memoryTotal = memTotal
                self.memoryPercentage = memTotal > 0 ? Double(memUsed) / Double(memTotal) * 100 : 0
                self.networkDownloadSpeed = downloadSpeed
                self.networkUploadSpeed = uploadSpeed
                self.isRefreshing = false
            }
        }
    }

    // MARK: - CPU Usage (Delta based)

    private func getCPUUsage() -> Double {
        var cpuInfo: host_cpu_load_info = host_cpu_load_info()
        var count = mach_msg_type_number_t(MemoryLayout<host_cpu_load_info>.size / MemoryLayout<integer_t>.size)

        let result = withUnsafeMutablePointer(to: &cpuInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &count)
            }
        }

        guard result == KERN_SUCCESS else { return 0 }

        let userTicks = UInt64(cpuInfo.cpu_ticks.0)
        let systemTicks = UInt64(cpuInfo.cpu_ticks.1)
        let idleTicks = UInt64(cpuInfo.cpu_ticks.2)
        let niceTicks = UInt64(cpuInfo.cpu_ticks.3)

        // Calculate delta from previous reading
        let deltaUser = userTicks > previousCpuTicks.user ? userTicks - previousCpuTicks.user : 0
        let deltaSystem = systemTicks > previousCpuTicks.system ? systemTicks - previousCpuTicks.system : 0
        let deltaIdle = idleTicks > previousCpuTicks.idle ? idleTicks - previousCpuTicks.idle : 0
        let deltaNice = niceTicks > previousCpuTicks.nice ? niceTicks - previousCpuTicks.nice : 0

        let deltaTotal = deltaUser + deltaSystem + deltaIdle + deltaNice
        let deltaUsed = deltaUser + deltaSystem + deltaNice

        // Store current values for next calculation
        previousCpuTicks = (userTicks, systemTicks, idleTicks, niceTicks)

        // Calculate usage percentage from delta
        return deltaTotal > 0 ? Double(deltaUsed) / Double(deltaTotal) * 100 : 0
    }

    // MARK: - Memory Usage

    private func getMemoryUsage() -> (used: UInt64, total: UInt64) {
        let physicalMemory = ProcessInfo.processInfo.physicalMemory

        var vmStats = vm_statistics64()
        var count = mach_msg_type_number_t(MemoryLayout<vm_statistics64>.size / MemoryLayout<integer_t>.size)

        let result = withUnsafeMutablePointer(to: &vmStats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count)
            }
        }

        guard result == KERN_SUCCESS else { return (0, physicalMemory) }

        let pageSize = UInt64(vm_kernel_page_size)

        // More accurate memory calculation for macOS:
        // Used = active + wired + compressed (compressed_count is the compressed in memory)
        // Note: speculative is cache that can be reclaimed, not counted as "used"
        let active = UInt64(vmStats.active_count)
        let wired = UInt64(vmStats.wire_count)
        let compressed = UInt64(vmStats.compressor_page_count)
        let speculative = UInt64(vmStats.speculative_count)

        // Total used memory (active + wired + compressed)
        let used = (active + wired + compressed) * pageSize

        return (used, physicalMemory)
    }

    // MARK: - Network Speed

    private func getNetworkSpeed() -> (download: Double, upload: Double) {
        var interfaceAddresses: UnsafeMutablePointer<ifaddrs>?
        var totalIn: UInt64 = 0
        var totalOut: UInt64 = 0

        guard getifaddrs(&interfaceAddresses) == 0 else { return (0, 0) }

        var pointer = interfaceAddresses
        while pointer != nil {
            let addr = pointer!.pointee

            if addr.ifa_addr?.pointee.sa_family == UInt8(AF_LINK) {
                if let data = addr.ifa_data {
                    let networkData = data.withMemoryRebound(to: if_data.self, capacity: 1) { $0.pointee }
                    totalIn += UInt64(networkData.ifi_ibytes)
                    totalOut += UInt64(networkData.ifi_obytes)
                }
            }

            pointer = addr.ifa_next
        }

        freeifaddrs(interfaceAddresses)

        // Calculate speed
        let now = Date()
        let elapsed = now.timeIntervalSince(previousTime)

        var downloadSpeed: Double = 0
        var uploadSpeed: Double = 0

        if elapsed > 0 && previousTime != now {
            let deltaIn = totalIn > previousDownload ? totalIn - previousDownload : 0
            let deltaOut = totalOut > previousUpload ? totalOut - previousUpload : 0
            downloadSpeed = Double(deltaIn) / elapsed / 1024 // KB/s
            uploadSpeed = Double(deltaOut) / elapsed / 1024 // KB/s
        }

        previousDownload = totalIn
        previousUpload = totalOut
        previousTime = now

        return (max(0, downloadSpeed), max(0, uploadSpeed))
    }

    // MARK: - Formatting

    func formatMemory(_ bytes: UInt64) -> String {
        let gb = Double(bytes) / 1_073_741_824.0 // 1024^3
        if gb >= 1 {
            return String(format: "%.1f GB", gb)
        } else {
            let mb = Double(bytes) / 1_048_576.0 // 1024^2
            return String(format: "%.0f MB", mb)
        }
    }

    func formatSpeed(_ kbps: Double) -> String {
        if kbps >= 1024 {
            return String(format: "%.1f MB/s", kbps / 1024)
        } else {
            return String(format: "%.0f KB/s", max(0, kbps))
        }
    }

    // MARK: - Update settings

    func updateRefreshInterval(_ interval: Double) {
        stopMonitoring()
        startMonitoring()
    }
}