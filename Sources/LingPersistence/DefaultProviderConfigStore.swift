import Foundation
import LingCore

public struct DefaultProviderConfigStore: ProviderConfigStore {
    public init() {}
    
    public func load() async throws -> TranslationProviderConfig {
        if let config = ConfigManager.shared.loadConfig() {
            return config
        } else {
            // Default values if no config exists
            return TranslationProviderConfig(
                provider: .openAICompatible,
                baseURL: URL(string: "https://api.openai.com/v1")!,
                model: "gpt-3.5-turbo",
                apiKey: "",
                defaultPrompt: "You are a professional translator. Translate the following text to Chinese. Keep the tone natural and preserve any formatting."
            )
        }
    }
    
    public func save(_ config: TranslationProviderConfig) async throws {
        try ConfigManager.shared.saveConfig(config)
    }
}
