import Foundation
import LingCore
import LingPersistence

@MainActor
public final class SavedViewModel: ObservableObject {
    @Published public private(set) var items: [TranslationItem] = []
    @Published public var errorMessage: String?

    private let savedItemsStore: SavedItemsStore

    public init(environment: AppEnvironment) {
        self.savedItemsStore = environment.savedItemsStore
    }

    public func load() {
        Task {
            do {
                items = try await savedItemsStore.load()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    public func delete(at offsets: IndexSet) {
        Task {
            for index in offsets {
                guard items.indices.contains(index) else { continue }
                let item = items[index]
                do {
                    try await savedItemsStore.remove(id: item.id)
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
            load()
        }
    }
}
