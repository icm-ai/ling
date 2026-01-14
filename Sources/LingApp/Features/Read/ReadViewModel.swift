import Foundation
import LingCore
import LingServices
import LingPersistence

@MainActor
public final class ReadViewModel: ObservableObject {
    @Published public var inputText: String = ""
    @Published public var translatedText: String = ""
    @Published public var isTranslating: Bool = false
    @Published public var errorMessage: String?
    @Published public private(set) var canSave: Bool = false

    private let translationService: TranslationService
    private let savedItemsStore: SavedItemsStore
    private let providerConfigStore: ProviderConfigStore
    private var currentContext: TranslationRequestContext?

    public init(environment: AppEnvironment) {
        self.translationService = environment.translationService
        self.savedItemsStore = environment.savedItemsStore
        self.providerConfigStore = environment.providerConfigStore
    }

    public func translate() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "请输入需要翻译的文本"
            return
        }

        Task {
            isTranslating = true
            errorMessage = nil
            canSave = false

            do {
                let config = try await providerConfigStore.load()
                let context = TranslationRequestContext(prompt: config.defaultPrompt)
                currentContext = context

                let result = try await translationService.translate(
                    inputText,
                    config: config,
                    context: context
                )

                translatedText = result.translatedText
                canSave = true
            } catch {
                errorMessage = error.localizedDescription
            }

            isTranslating = false
        }
    }

    public func save() {
        guard canSave else { return }

        Task {
            let item = TranslationItem(
                originalText: inputText,
                translatedText: translatedText,
                sourceMetadata: currentContext?.sourceMetadata
            )
            do {
                try await savedItemsStore.add(item)
                canSave = false
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
