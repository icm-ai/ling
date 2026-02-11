import SwiftUI

public struct ReadView: View {
    @StateObject private var viewModel: ReadViewModel

    public init(viewModel: ReadViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Input Text")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        TextEditor(text: $viewModel.inputText)
                            .frame(minHeight: 160)
                            .padding(8)
                            #if os(iOS)
                            .background(Color(uiColor: .systemBackground))
                            #else
                            .background(Color(NSColor.textBackgroundColor))
                            #endif
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(LinearGradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    }

                    HStack(spacing: 16) {
                        Button(action: viewModel.translate) {
                            HStack {
                                if viewModel.isTranslating {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Image(systemName: "sparkles")
                                    Text("Translate")
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                        }
                        .buttonStyle(.borderedProminent)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .disabled(viewModel.isTranslating || viewModel.inputText.isEmpty)

                        if viewModel.canSave {
                            Button(action: viewModel.save) {
                                HStack {
                                    Image(systemName: "plus.square")
                                    Text("Save")
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 24)
                            }
                            .buttonStyle(.bordered)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .animation(.spring(), value: viewModel.canSave)

                    if !viewModel.translatedText.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Translation")
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Button {
                                    #if os(iOS)
                                    UIPasteboard.general.string = viewModel.translatedText
                                    #elseif os(macOS)
                                    NSPasteboard.general.clearContents()
                                    NSPasteboard.general.setString(viewModel.translatedText, forType: .string)
                                    #endif
                                } label: {
                                    Image(systemName: "doc.on.doc")
                                        .foregroundStyle(.blue)
                                }
                            }
                            
                            Text(viewModel.translatedText)
                                .font(.system(.body, design: .rounded))
                                .padding(16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            #if os(iOS)
                                            .fill(Color(uiColor: .secondarySystemBackground))
                                            #else
                                            .fill(Color.secondary.opacity(0.1))
                                            #endif
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.blue.opacity(0.1), lineWidth: 1)
                                    }
                                )
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }

                    if let error = viewModel.errorMessage {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                            Text(error)
                        }
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(12)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding()
            }
            #if os(iOS)
            .background(Color(uiColor: .systemGroupedBackground))
            #else
            .background(Color(NSColor.windowBackgroundColor))
            #endif
            .navigationTitle("Read")
            .onAppear(perform: viewModel.checkClipboard)
            #if os(iOS)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                viewModel.checkClipboard()
            }
            #elseif os(macOS)
            .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
                viewModel.checkClipboard()
            }
            #endif
            .animation(.easeInOut, value: viewModel.translatedText)
        }
    }
}
