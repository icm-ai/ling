import Foundation
import LingCore

public protocol SavedItemsStore {
    func load() async throws -> [TranslationItem]
    func add(_ item: TranslationItem) async throws
    func remove(id: UUID) async throws
}
