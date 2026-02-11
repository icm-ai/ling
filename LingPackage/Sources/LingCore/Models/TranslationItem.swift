import Foundation

public struct TranslationItem: Identifiable, Codable, Hashable {
    public let id: UUID
    public var originalText: String
    public var translatedText: String
    public var createdAt: Date
    public var sourceMetadata: String?

    public init(
        id: UUID = UUID(),
        originalText: String,
        translatedText: String,
        createdAt: Date = Date(),
        sourceMetadata: String? = nil
    ) {
        self.id = id
        self.originalText = originalText
        self.translatedText = translatedText
        self.createdAt = createdAt
        self.sourceMetadata = sourceMetadata
    }
}
