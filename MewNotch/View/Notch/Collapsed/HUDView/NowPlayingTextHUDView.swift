//
//  NowPlayingTextHUDView.swift
//  MewNotch
//

import SwiftUI

struct NowPlayingTextHUDView: View {

    @ObservedObject var notchViewModel: NotchViewModel

    var hudModel: HUDPropertyModel?

    @StateObject var notchDefaults = NotchDefaults.shared

    private var minNotchHeight: CGFloat {
        notchViewModel.cornerRadius.top + notchViewModel.cornerRadius.bottom + 10
    }

    private var useNotchShape: Bool {
        notchViewModel.notchSize.height >= minNotchHeight
    }

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
                        .clipShape(
                            useNotchShape
                            ? AnyShape(NotchShape(
                                topRadius: notchViewModel.cornerRadius.top,
                                bottomRadius: notchViewModel.cornerRadius.bottom
                            ))
                            : AnyShape(RoundedRectangle(cornerRadius: 8))
                        )
                } else {
                    Rectangle()
                        .fill(Color.black)
                        .clipShape(
                            useNotchShape
                            ? AnyShape(NotchShape(
                                topRadius: notchViewModel.cornerRadius.top,
                                bottomRadius: notchViewModel.cornerRadius.bottom
                            ))
                            : AnyShape(RoundedRectangle(cornerRadius: 8))
                        )
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

// Helper for type erasure
struct AnyShape: Shape {
    private let _path: (CGRect) -> Path

    init<S: Shape>(_ shape: S) {
        _path = { rect in shape.path(in: rect) }
    }

    func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}
