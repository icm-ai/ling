import Foundation
import LingCore

public final class TranslationServiceImplementation: TranslationService {
    private let client: LLMClient
    
    public init(client: LLMClient = LLMClient()) {
        self.client = client
    }
    
    public func translate(
        _ text: String,
        config: TranslationProviderConfig,
        context: TranslationRequestContext
    ) async throws -> TranslationResult {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw TranslationError.emptyInput
        }
        
        do {
            return try await client.translate(text: text, config: config, context: context)
        } catch let error as LLMClient.LLMError {
            throw TranslationError.networkFailure(error.localizedDescription)
        } catch {
            throw TranslationError.networkFailure(error.localizedDescription)
        }
    }
}
