//
//  CollapsedNotchView.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/02/25.
//

import SwiftUI

import Lottie

struct CollapsedNotchView: View {
    
    var namespace: Namespace.ID
    
    @ObservedObject var notchViewModel: NotchViewModel
    
    @StateObject var collapsedNotchViewModel: CollapsedNotchViewModel = .init()
    
    @StateObject var notchDefaults = NotchDefaults.shared

    @StateObject private var timerManager = TimerManager.shared
    @StateObject private var calendarManager = CalendarManager.shared
    @StateObject private var calendarDefaults = CalendarDefaults.shared

    /// Show calendar HUD when enabled
    private var showCalendarHUD: Bool {
        calendarDefaults.showInNotch
    }
    
    @StateObject var mediaDefaults = HUDMediaDefaults.shared
    
    var body: some View {
        VStack(
            spacing: 0
        ) {
            HStack(
                spacing: 2
            ) {
                Spacer()
                    .frame(width: 6)

                MinimalHUDLeftView(
                    notchViewModel: notchViewModel,
                    defaults: HUDBrightnessDefaults.shared,
                    hudModel: collapsedNotchViewModel.brightnessHUD
                )
                
                MinimalHUDLeftView(
                    notchViewModel: notchViewModel,
                    defaults: HUDAudioInputDefaults.shared,
                    hudModel: collapsedNotchViewModel.inputAudioVolumeHUD
                )
                
                MinimalHUDLeftView(
                    notchViewModel: notchViewModel,
                    defaults: HUDAudioOutputDefaults.shared,
                    hudModel: collapsedNotchViewModel.outputAudioVolumeHUD
                )
                
                ScreenLockHUDView(
                    notchViewModel: notchViewModel,
                    hudModel: collapsedNotchViewModel.lockStatusHUD
                )
                
                NowPlayingHUDLeftView(
                    namespace: namespace,
                    notchViewModel: notchViewModel,
                    nowPlayingModel: collapsedNotchViewModel.nowPlayingMedia
                )
                .hide(
                    when: !mediaDefaults.isEnabled
                )
                .hide(
                    when: notchViewModel.isExpanded
                )

                // System monitor CPU (left side, outermost)
                SystemMonitorHUDLeftView(notchViewModel: notchViewModel)

                // Timer icon on left side of notch
                TimerHUDLeftView(notchViewModel: notchViewModel)

                // Calendar countdown (left side, innermost)
                CalendarHUDLeftView(notchViewModel: notchViewModel)

                Spacer()
                    .frame(width: 8)

                OnlyNotchView(
                    notchSize: notchViewModel.notchSize
                )

                Spacer()
                    .frame(width: 8)

                // Calendar event title (right side, innermost)
                CalendarHUDRightView(notchViewModel: notchViewModel)
                    .opacity(showCalendarHUD ? 1 : 0)

                // Timer time on right side of notch
                TimerHUDRightView(notchViewModel: notchViewModel)

                // System monitor Memory (right side, outermost)
                SystemMonitorHUDRightView(notchViewModel: notchViewModel)

                NowPlayingHUDRightView(
                    notchViewModel: notchViewModel,
                    nowPlayingModel: collapsedNotchViewModel.nowPlayingMedia
                )
                .hide(
                    when: !mediaDefaults.isEnabled
                )
                .hide(
                    when: notchViewModel.isExpanded
                )
                
                MinimalHUDView(
                    notchViewModel: notchViewModel,
                    variant: .right
                ) {
                    Text("")
                }
                .hide(
                    when: collapsedNotchViewModel.lockStatusHUD == nil
                )
                
                MinimalHUDRightView(
                    notchViewModel: notchViewModel,
                    defaults: HUDAudioOutputDefaults.shared,
                    hudModel: collapsedNotchViewModel.outputAudioVolumeHUD
                )
                
                MinimalHUDRightView(
                    notchViewModel: notchViewModel,
                    defaults: HUDAudioInputDefaults.shared,
                    hudModel: collapsedNotchViewModel.inputAudioVolumeHUD
                )
                
                MinimalHUDRightView(
                    notchViewModel: notchViewModel,
                    defaults: HUDBrightnessDefaults.shared,
                    hudModel: collapsedNotchViewModel.brightnessHUD
                )

                Spacer()
                    .frame(width: 6)
            }
            
            PowerHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDPowerDefaults.shared,
                hudModel: collapsedNotchViewModel.powerStatusHUD
            )
            
            AudioDeviceHUDView(
                notchViewModel: notchViewModel,
                deviceType: .Input,
                hudModel: collapsedNotchViewModel.inputAudioDeviceHUD
            )
            
            AudioDeviceHUDView(
                notchViewModel: notchViewModel,
                deviceType: .Output,
                hudModel: collapsedNotchViewModel.outputAudioDeviceHUD
            )
            
            // MARK: Progress Style Views
            ProgressHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDBrightnessDefaults.shared,
                hudModel: collapsedNotchViewModel.brightnessHUD
            )
            
            ProgressHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDAudioInputDefaults.shared,
                hudModel: collapsedNotchViewModel.inputAudioVolumeHUD
            )
            
            ProgressHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDAudioOutputDefaults.shared,
                hudModel: collapsedNotchViewModel.outputAudioVolumeHUD
            )
            
            // MARK: Notched Style View
            
            NotchedHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDBrightnessDefaults.shared,
                hudModel: collapsedNotchViewModel.brightnessHUD
            )
            
            NotchedHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDAudioInputDefaults.shared,
                hudModel: collapsedNotchViewModel.inputAudioVolumeHUD
            )
            
            NotchedHUDView(
                notchViewModel: notchViewModel,
                defaults: HUDAudioOutputDefaults.shared,
                hudModel: collapsedNotchViewModel.outputAudioVolumeHUD
            )
        }
        .onReceive(
            notchDefaults.objectWillChange
        ) {
            collapsedNotchViewModel.hideHUDs()
            
            notchViewModel.refreshNotchSize()
        }
    }
}
