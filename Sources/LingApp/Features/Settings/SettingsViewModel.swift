import Foundation
import LingCore
import LingServices
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
    @Published public var isTesting: Bool = false
    
    // Export state
    @Published public var showExportSheet: Bool = false
    @Published public var exportContent: String = ""
    @Published public var exportFormat: ExportFormat = .markdown

    private let providerConfigStore: ProviderConfigStore
    private let translationService: TranslationService
    private let savedItemsStore: SavedItemsStore

    public init(environment: AppEnvironment) {
        self.providerConfigStore = environment.providerConfigStore
        self.translationService = environment.translationService
        self.savedItemsStore = environment.savedItemsStore
    }
    
    public enum ExportFormat: String, CaseIterable {
        case markdown = "Markdown"
        case json = "JSON"
    }
    
    public func prepareExport(format: ExportFormat) {
        Task {
            do {
                let items = try await savedItemsStore.load()
                
                switch format {
                case .markdown:
                    exportContent = generateMarkdown(from: items)
                case .json:
                    exportContent = try generateJSON(from: items)
                }
                
                exportFormat = format
                showExportSheet = true
            } catch {
                statusMessage = "导出失败: \(error.localizedDescription)"
            }
        }
    }
    
    private func generateMarkdown(from items: [TranslationItem]) -> String {
        var markdown = "# Ling Translations Export\n\n"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        for item in items {
            markdown += "## \(dateFormatter.string(from: item.createdAt))\n\n"
            markdown += "**Original:**\n> \(item.originalText.replacingOccurrences(of: "\n", with: "\n> "))\n\n"
            markdown += "**Translation:**\n\(item.translatedText)\n\n"
            markdown += "---\n\n"
        }
        return markdown
    }
    
    private func generateJSON(from items: [TranslationItem]) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(items)
        return String(data: data, encoding: .utf8) ?? "{}"
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
                statusMessage = "加载配置失败: \(error.localizedDescription)"
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
                statusMessage = "✅ 配置已保存"
            } catch {
                statusMessage = "❌ 保存失败: \(error.localizedDescription)"
            }

            isSaving = false
        }
    }

    public func testConnection() {
        guard let url = URL(string: baseURLString) else {
            statusMessage = "Base URL 无效"
            return
        }

        if apiKey.isEmpty {
            statusMessage = "请输入 API Key"
            return
        }

        Task {
            isTesting = true
            statusMessage = "正在测试连接..."
            
            let config = TranslationProviderConfig(
                provider: provider,
                baseURL: url,
                model: model,
                apiKey: apiKey,
                defaultPrompt: prompt
            )
            
            let context = TranslationRequestContext(prompt: prompt)
            
            do {
                _ = try await translationService.translate("Hello", config: config, context: context)
                statusMessage = "✅ 连接成功！"
            } catch {
                statusMessage = "❌ 连接失败: \(error.localizedDescription)"
            }
            
            isTesting = false
        }
    }
}
