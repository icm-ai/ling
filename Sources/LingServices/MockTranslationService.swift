import Foundation
import LingCore

public actor MockTranslationService: TranslationService {
    public init() {}

    public func translate(
        _ text: String,
        config: TranslationProviderConfig,
        context: TranslationRequestContext
    ) async throws -> TranslationResult {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw TranslationError.emptyInput
        }

        // Simulate network delay and a deterministic "translation".
        try await Task.sleep(nanoseconds: 200_000_000)
        let translated = "[\(config.model)] \(text)"
        return TranslationResult(translatedText: translated, detectedLanguage: nil)
    }
}
