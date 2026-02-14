#if os(iOS)
import SwiftUI
import Translation
import LingCore
import LingServices
import LingPersistence
import LingExtension
import TranslationUIProvider

@available(iOS 18.4, *)
public struct TranslationFeatureImplementation: TranslationUIProviderExtension {
    public init() {}
    
    public var body: some TranslationUIProviderExtensionScene {
        TranslationUIProviderSelectedTextScene { selection in
            TranslationProviderView(text: selection.inputText.map { String($0.characters) } ?? "")
        }
    }
}

@available(iOS 18.0, *)
struct TranslationProviderView: View {
    let text: String
    @StateObject private var viewModel = ExtensionViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isTranslating {
                ProgressView("正在翻译...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 40))
                        .foregroundColor(.orange)
                    Text(error)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("原文")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                            Text(viewModel.originalText)
                                .font(.body)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(12)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("翻译")
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
                
                HStack {
                    Button(action: viewModel.save) {
                        HStack {
                            if viewModel.isSaved {
                                Image(systemName: "checkmark")
                                .font(.body)
                                Text("已保存")
                            } else {
                                Image(systemName: "square.and.arrow.down")
                                .font(.body)
                                Text("保存到 Ling")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                    .disabled(viewModel.isSaved || viewModel.translatedText.isEmpty)
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.load(text: text)
        }
    }
}
#endif
