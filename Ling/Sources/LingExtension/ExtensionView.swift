import SwiftUI

public struct ExtensionView: View {
    @StateObject private var viewModel = ExtensionViewModel()
    var inputText: String
    var onDone: () -> Void
    
    public init(inputText: String, onDone: @escaping () -> Void) {
        self.inputText = inputText
        self.onDone = onDone
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if viewModel.isTranslating {
                    Spacer()
                    ProgressView("Translating...")
                    Spacer()
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 40))
                            .foregroundColor(.orange)
                        Text(error)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("ORIGINAL")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                                Text(viewModel.originalText)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            #if os(iOS)
                            .background(Color(uiColor: .secondarySystemBackground))
                            #else
                            .background(Color.secondary.opacity(0.1))
                            #endif
                            .cornerRadius(12)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("TRANSLATION")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                                Text(viewModel.translatedText)
                                    .font(.title3)
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .padding()
                    }
                }
                
                VStack(spacing: 12) {
                    Divider()
                    HStack {
                        if !viewModel.translatedText.isEmpty {
                            Button(action: viewModel.save) {
                                HStack {
                                    if viewModel.isSaved {
                                        Image(systemName: "checkmark")
                                        Text("Saved")
                                    } else {
                                        Image(systemName: "square.and.arrow.down")
                                        Text("Save to Ling")
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                            }
                            .buttonStyle(.bordered)
                            .tint(.blue)
                            .disabled(viewModel.isSaved)
                        }
                        
                        Button(action: onDone) {
                            Text("Done")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }
                #if os(iOS)
                .background(Color(uiColor: .systemBackground))
                #else
                .background(Color(NSColor.windowBackgroundColor))
                #endif
            }
            .navigationTitle("Ling Translate")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: onDone)
                }
            }
            .onAppear {
                viewModel.load(text: inputText)
            }
        }
    }
}
