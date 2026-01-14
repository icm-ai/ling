import Foundation

public enum TranslationProvider: String, Codable, CaseIterable, Hashable {
    case openAICompatible = "openai-compatible"
    case deepSeekCompatible = "deepseek-compatible"
}

public struct TranslationProviderConfig: Codable, Equatable {
    public var provider: TranslationProvider
    public var baseURL: URL
    public var model: String
    public var apiKey: String
    public var defaultPrompt: String

    public init(
        provider: TranslationProvider,
        baseURL: URL,
        model: String,
        apiKey: String,
        defaultPrompt: String
    ) {
        self.provider = provider
        self.baseURL = baseURL
        self.model = model
        self.apiKey = apiKey
        self.defaultPrompt = defaultPrompt
    }
}

public struct TranslationRequestContext: Codable, Equatable {
    public var prompt: String
    public var sourceMetadata: String?

    public init(prompt: String, sourceMetadata: String? = nil) {
        self.prompt = prompt
        self.sourceMetadata = sourceMetadata
    }
}

public struct TranslationResult: Codable, Equatable {
    public var translatedText: String
    public var detectedLanguage: String?

    public init(translatedText: String, detectedLanguage: String? = nil) {
        self.translatedText = translatedText
        self.detectedLanguage = detectedLanguage
    }
}
