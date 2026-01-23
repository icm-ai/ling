import Foundation
import LingCore
import LingServices
import LingPersistence

public struct AppEnvironment {
    public let translationService: TranslationService
    public let savedItemsStore: SavedItemsStore
    public let providerConfigStore: ProviderConfigStore

    public init(
        translationService: TranslationService,
        savedItemsStore: SavedItemsStore,
        providerConfigStore: ProviderConfigStore
    ) {
        self.translationService = translationService
        self.savedItemsStore = savedItemsStore
        self.providerConfigStore = providerConfigStore
    }
}

public extension AppEnvironment {
    static func inMemory() -> AppEnvironment {
        AppEnvironment(
            translationService: MockTranslationService(),
            savedItemsStore: InMemorySavedItemsStore(),
            providerConfigStore: InMemoryProviderConfigStore()
        )
    }
    
    static func live() -> AppEnvironment {
        AppEnvironment(
            translationService: TranslationServiceImplementation(),
            savedItemsStore: LingDataStore.shared, // Assuming LingDataStore will implement SavedItemsStore or similar
            providerConfigStore: DefaultProviderConfigStore()
        )
    }
}
