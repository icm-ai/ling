import Foundation
import LingCore

public actor InMemorySavedItemsStore: SavedItemsStore {
    private var items: [UUID: TranslationItem] = [:]

    public init() {}

    public func load() async throws -> [TranslationItem] {
        items.values.sorted { $0.createdAt > $1.createdAt }
    }

    public func add(_ item: TranslationItem) async throws {
        items[item.id] = item
    }

    public func remove(id: UUID) async throws {
        items[id] = nil
    }
}
