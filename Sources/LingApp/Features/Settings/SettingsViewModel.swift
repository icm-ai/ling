import Foundation
import LingCore
import LingPersistence

@MainActor
public final class SettingsViewModel: ObservableObject {
    @Published public var provider: TranslationProvider = .openAICompatible
    @Published public var baseURLString: String = ""
    @Published public var model: String = ""
    @Published public var apiKey: String = ""
    @Published public var prompt: String = ""
    @Published public var statusMessage: String?
    @Published public var isSaving: Bool = false

    private let providerConfigStore: ProviderConfigStore

    public init(environment: AppEnvironment) {
        self.providerConfigStore = environment.providerConfigStore
    }

    public func load() {
        Task {
            do {
                let config = try await providerConfigStore.load()
                provider = config.provider
                baseURLString = config.baseURL.absoluteString
                model = config.model
                apiKey = config.apiKey
                prompt = config.defaultPrompt
            } catch {
                statusMessage = error.localizedDescription
            }
        }
    }

    public func save() {
        guard let url = URL(string: baseURLString) else {
            statusMessage = "Base URL 无效"
            return
        }

        Task {
            isSaving = true
            let config = TranslationProviderConfig(
                provider: provider,
                baseURL: url,
                model: model,
                apiKey: apiKey,
                defaultPrompt: prompt
            )

            do {
                try await providerConfigStore.save(config)
                statusMessage = "配置已保存"
            } catch {
                statusMessage = error.localizedDescription
            }

            isSaving = false
        }
    }
}
