import Foundation
import LingCore

public actor InMemoryProviderConfigStore: ProviderConfigStore {
    private var storedConfig: TranslationProviderConfig?

    public init() {}

    public func load() async throws -> TranslationProviderConfig {
        if let config = storedConfig {
            return config
        }

        // Provide a sane default for early development.
        let defaultURL = URL(string: "https://api.openai.com/v1")!
        let config = TranslationProviderConfig(
            provider: .openAICompatible,
            baseURL: defaultURL,
            model: "gpt-4o-mini",
            apiKey: "",
            defaultPrompt: "You are a professional translator. Translate faithfully and naturally."
        )
        storedConfig = config
        return config
    }

    public func save(_ config: TranslationProviderConfig) async throws {
        storedConfig = config
    }
}
