//
//  TeleprompterView.swift
//  MewNotch
//

import SwiftUI

struct TeleprompterView: View {

    @ObservedObject var viewModel = TeleprompterViewModel.shared
    @ObservedObject var notchViewModel: NotchViewModel
    @ObservedObject var defaults = TeleprompterDefaults.shared

    @State private var isEditing: Bool = false
    @State private var showScriptList: Bool = false

    var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                Image(systemName: "text.alignleft")
                    .foregroundColor(MewNotch.Colors.teleprompter.color)

                Text("teleprompter")
                    .font(.system(size: 14, weight: .semibold))

                Spacer()

                if viewModel.isScrolling {
                    Button {
                        viewModel.stopScrolling()
                    } label: {
                        Image(systemName: "pause.fill")
                            .foregroundColor(.orange)
                    }
                    .buttonStyle(.plain)
                } else {
                    Button {
                        viewModel.startScrolling()
                    } label: {
                        Image(systemName: "play.fill")
                            .foregroundColor(.green)
                    }
                    .buttonStyle(.plain)
                }

                Button {
                    viewModel.resetScroll()
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundColor(.gray)
                }
                .buttonStyle(.plain)
            }

            // Script content
            ScrollViewReader { proxy in
                ScrollView {
                    Text(viewModel.currentText)
                        .font(.system(size: defaults.fontSize))
                        .foregroundColor(.white)
                        .multilineTextAlignment(mapAlignment())
                        .padding()
                        .id("top")
                        .offset(y: -viewModel.scrollOffset)
                }
                .frame(height: 200)
                .background(Color.black.opacity(0.3))
                .cornerRadius(8)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            viewModel.manualScroll(delta: value.translation.height * -0.5)
                        }
                )
            }

            // Controls
            HStack(spacing: 16) {
                // Speed control
                VStack(alignment: .leading, spacing: 4) {
                    Text("speed")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Slider(value: $defaults.scrollSpeed, in: 0.5...10, step: 0.5)
                        .frame(width: 100)
                }

                // Font size
                VStack(alignment: .leading, spacing: 4) {
                    Text("font")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Slider(value: $defaults.fontSize, in: 12...48, step: 2)
                        .frame(width: 100)
                }

                Spacer()

                // Import buttons
                Button {
                    let panel = NSOpenPanel()
                    panel.allowedContentTypes = [.text]
                    panel.allowsMultipleSelection = false
                    if panel.runModal() == .OK, let url = panel.url {
                        viewModel.importTextFromFile(url)
                    }
                } label: {
                    Image(systemName: "doc.text.fill")
                        .foregroundColor(.blue)
                }
                .buttonStyle(.plain)

                Button {
                    viewModel.pasteFromClipboard()
                } label: {
                    Image(systemName: "clipboard.fill")
                        .foregroundColor(.purple)
                }
                .buttonStyle(.plain)

                Button {
                    showScriptList.toggle()
                } label: {
                    Image(systemName: "list.bullet")
                        .foregroundColor(.cyan)
                }
                .buttonStyle(.plain)
            }

            // Script list
            if showScriptList {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(defaults.scripts) { script in
                            HStack {
                                Text(script.title)
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)

                                Spacer()

                                Button {
                                    viewModel.selectScript(script)
                                    showScriptList = false
                                } label: {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.green)
                                        .opacity(defaults.currentScriptId == script.id ? 1 : 0)
                                }
                                .buttonStyle(.plain)

                                Button {
                                    viewModel.deleteScript(script)
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(4)
                        }
                    }
                }
                .frame(height: 100)
            }
        }
        .padding(12)
    }

    private func mapAlignment() -> TextAlignment {
        switch defaults.textAlignment {
        case "center": return .center
        case "right": return .trailing
        default: return .leading
        }
    }
}