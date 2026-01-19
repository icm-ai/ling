import Foundation
import LingCore

public final class LLMClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public enum LLMError: Error, LocalizedError {
        case invalidURL
        case unauthorized
        case rateLimited
        case serverError(Int)
        case decodingError(Error)
        case unknown(Error)
        
        public var errorDescription: String? {
            switch self {
            case .invalidURL: return "Invalid API URL."
            case .unauthorized: return "API Key is invalid or expired."
            case .rateLimited: return "Rate limit exceeded. Please try again later."
            case .serverError(let code): return "Server error (Code: \(code))."
            case .decodingError(let error): return "Failed to decode response: \(error.localizedDescription)"
            case .unknown(let error): return error.localizedDescription
            }
        }
    }
    
    public func translate(
        text: String,
        config: TranslationProviderConfig,
        context: TranslationRequestContext? = nil
    ) async throws -> TranslationResult {
        guard let url = URL(string: config.baseURL.absoluteString + "/chat/completions") else {
            throw LLMError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(config.apiKey)", forHTTPHeaderField: "Authorization")
        
        let systemPrompt = config.defaultPrompt
        let userPrompt = text
        
        let body: [String: Any] = [
            "model": config.model,
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": userPrompt]
            ],
            "temperature": 0.3
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw LLMError.unknown(NSError(domain: "LLMClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response type"]))
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401:
            throw LLMError.unauthorized
        case 429:
            throw LLMError.rateLimited
        default:
            throw LLMError.serverError(httpResponse.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            let openAIResponse = try decoder.decode(OpenAIResponse.self, from: data)
            guard let content = openAIResponse.choices.first?.message.content else {
                throw TranslationError.invalidResponse
            }
            return TranslationResult(translatedText: content.trimmingCharacters(in: .whitespacesAndNewlines))
        } catch {
            throw LLMError.decodingError(error)
        }
    }
}

// Internal OpenAI API definitions
private struct OpenAIResponse: Codable {
    struct Choice: Codable {
        struct Message: Codable {
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}
