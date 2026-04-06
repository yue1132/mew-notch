//
//  NotchHomeView.swift
//  MewNotch
//
//  Created by Monu Kumar on 09/07/25.
//

import SwiftUI

struct NotchHomeView: View {

    var namespace: Namespace.ID

    @StateObject private var notchDefaults = NotchDefaults.shared

    @ObservedObject var notchViewModel: NotchViewModel
    @ObservedObject var expandedNotchViewModel: ExpandedNotchViewModel

    var collapsedNotchView: CollapsedNotchView

    @ObservedObject private var bluetoothManager = BluetoothManager.shared
    @ObservedObject private var calendarManager = CalendarManager.shared

    var body: some View {
        let items = notchDefaults.expandedNotchItems
        let visibleItems = items.filter { shouldShow($0) }

        HStack(
            spacing: max(CGFloat(4), CGFloat(24 - visibleItems.count * 4))
        ) {
            ForEach(
                0..<visibleItems.count,
                id: \.self
            ) { index in

                let item = visibleItems[index]

                switch item {
                case .Mirror:
                    MirrorView(
                        notchViewModel: notchViewModel
                    )
                case .NowPlaying:
                    if let media = expandedNotchViewModel.nowPlayingMedia {
                        NowPlayingDetailView(
                            namespace: namespace,
                            notchViewModel: notchViewModel,
                            nowPlayingModel: media
                        )
                    }
                case .Bash:
                    BashView(notchViewModel: notchViewModel)
                case .Bluetooth:
                    BluetoothView(notchViewModel: notchViewModel)
                case .Calendar:
                    CalendarView(notchViewModel: notchViewModel)
                case .SystemMonitor:
                    SystemMonitorView(notchViewModel: notchViewModel)
                case .Timer:
                    TimerView(notchViewModel: notchViewModel)
                }

                if notchDefaults.showDividers && index != visibleItems.count - 1 {
                    Divider()
                }
            }

        }
        .frame(
            height: notchViewModel.notchSize.height * 3
        )
    }

    private func shouldShow(_ item: ExpandedNotchItem) -> Bool {
        switch item {
        case .Bluetooth:
            return !bluetoothManager.connectedAudioDevices.isEmpty
        case .Calendar:
            return true
        default:
            return true
        }
    }
}
