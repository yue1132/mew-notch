//
//  NowPlayingTextHUDView.swift
//  MewNotch
//

import SwiftUI

struct NowPlayingTextHUDView: View {

    @ObservedObject var notchViewModel: NotchViewModel

    var hudModel: HUDPropertyModel?

    @StateObject var notchDefaults = NotchDefaults.shared

    var body: some View {
        if let title = hudModel?.name, !title.isEmpty {
            VStack(
                spacing: 0
            ) {
                Text(LocalizedStringResource("now_playing"))
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(title)
                    .font(.body.bold())
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: notchViewModel.notchSize.width - notchViewModel.extraNotchPadSize.width)
            .padding(
                .init(
                    top: notchViewModel.notchSize.height * 0.3,
                    leading: 10,
                    bottom: notchViewModel.notchSize.height * 0.3,
                    trailing: 10
                )
            )
            .padding(
                .horizontal, notchViewModel.extraNotchPadSize.width / 2
            )
            .background {
                if notchDefaults.applyGlassEffect {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .clipShape(NotchShape(
                            topRadius: notchViewModel.cornerRadius.top,
                            bottomRadius: notchViewModel.cornerRadius.bottom
                        ))
                } else {
                    Rectangle()
                        .fill(Color.black)
                        .clipShape(NotchShape(
                            topRadius: notchViewModel.cornerRadius.top,
                            bottomRadius: notchViewModel.cornerRadius.bottom
                        ))
                }
            }
            .transition(
                .move(
                    edge: .top
                )
                .combined(
                    with: .opacity
                )
            )
        }
    }
}
