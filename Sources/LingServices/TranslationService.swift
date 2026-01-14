import Foundation
import LingCore

public protocol TranslationService {
    func translate(
        _ text: String,
        config: TranslationProviderConfig,
        context: TranslationRequestContext
    ) async throws -> TranslationResult
}

public enum TranslationError: Error, LocalizedError {
    case emptyInput
    case invalidResponse
    case networkFailure(String)

    public var errorDescription: String? {
        switch self {
        case .emptyInput:
            return "Input text is empty."
        case .invalidResponse:
            return "Translation response was invalid."
        case .networkFailure(let reason):
            return "Translation failed: \(reason)"
        }
    }
}
