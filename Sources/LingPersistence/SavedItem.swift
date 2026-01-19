import Foundation
import SwiftData

@Model
public final class SavedItem {
    @Attribute(.unique) public var id: UUID
    public var originalText: String
    public var translatedText: String
    public var createdAt: Date
    public var source: String?
    
    public init(
        id: UUID = UUID(),
        originalText: String,
        translatedText: String,
        createdAt: Date = Date(),
        source: String? = nil
    ) {
        self.id = id
        self.originalText = originalText
        self.translatedText = translatedText
        self.createdAt = createdAt
        self.source = source
    }
}
