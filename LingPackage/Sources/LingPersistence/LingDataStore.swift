import Foundation
import SwiftData
import LingCore

public final class LingDataStore {
    public static let shared = LingDataStore()
    
    public let container: ModelContainer
    
    private init() {
        let schema = Schema([
            SavedItem.self
        ])
        
        let appGroupIdentifier = LingConstants.appGroupId
        
        // Use App Group shared directory for the database
        let modelConfiguration: ModelConfiguration
        if let sharedURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier) {
            let databaseURL = sharedURL.appendingPathComponent("Ling.sqlite")
            modelConfiguration = ModelConfiguration(schema: schema, url: databaseURL)
        } else {
            // Fallback to default if app group is not configured (e.g. during dev/tests)
            modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        }
        
        do {
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    @MainActor
    public var context: ModelContext {
        container.mainContext
    }
}

extension LingDataStore: SavedItemsStore {
    public func load() async throws -> [TranslationItem] {
        let descriptor = FetchDescriptor<SavedItem>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        return try await MainActor.run {
            let items = try context.fetch(descriptor)
            return items.map { 
                TranslationItem(
                    id: $0.id,
                    originalText: $0.originalText,
                    translatedText: $0.translatedText,
                    createdAt: $0.createdAt,
                    sourceMetadata: $0.source
                )
            }
        }
    }
    
    public func add(_ item: TranslationItem) async throws {
        await MainActor.run {
            let savedItem = SavedItem(
                id: item.id,
                originalText: item.originalText,
                translatedText: item.translatedText,
                createdAt: item.createdAt,
                source: item.sourceMetadata
            )
            context.insert(savedItem)
            try? context.save()
        }
    }
    
    public func remove(id: UUID) async throws {
        await MainActor.run {
            let itemID = id
            let descriptor = FetchDescriptor<SavedItem>(predicate: #Predicate { $0.id == itemID })
            if let results = try? context.fetch(descriptor), let item = results.first {
                context.delete(item)
                try? context.save()
            }
        }
    }
}
