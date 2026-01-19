import Foundation
import Combine
import LingCore
import LingServices
import LingPersistence

@MainActor
public final class ExtensionViewModel: ObservableObject {
    @Published public var originalText: String = ""
    @Published public var translatedText: String = ""
    @Published public var isTranslating: Bool = false
    @Published public var errorMessage: String?
    @Published public var isSaved: Bool = false
    
    private let translationService: TranslationService
    private let providerConfigStore: ProviderConfigStore
    private let savedItemsStore: SavedItemsStore
    
    public init() {
        self.translationService = TranslationServiceImplementation()
        self.providerConfigStore = DefaultProviderConfigStore()
        self.savedItemsStore = LingDataStore.shared
    }
    
    public func load(text: String) {
        self.originalText = text
        translate()
    }
    
    public func translate() {
        guard !originalText.isEmpty else { return }
        
        Task {
            isTranslating = true
            errorMessage = nil
            
            do {
                let config = try await providerConfigStore.load()
                // Validate API Key existence for better UX
                if config.apiKey.isEmpty {
                    errorMessage = "未配置 API Key，请先打开 Ling 主应用进行设置。"
                    isTranslating = false
                    return
                }
                
                let context = TranslationRequestContext(prompt: config.defaultPrompt, sourceMetadata: "Action Extension")
                
                let result = try await translationService.translate(
                    originalText,
                    config: config,
                    context: context
                )
                
                translatedText = result.translatedText
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isTranslating = false
        }
    }
    
    public func save() {
        guard !translatedText.isEmpty else { return }
        
        Task {
            let item = TranslationItem(
                originalText: originalText,
                translatedText: translatedText,
                sourceMetadata: "Action Extension"
            )
            
            do {
                try await savedItemsStore.add(item)
                isSaved = true
            } catch {
                errorMessage = "保存失败: \(error.localizedDescription)"
            }
        }
    }
}
