import Foundation
import LingCore

public protocol ProviderConfigStore {
    func load() async throws -> TranslationProviderConfig
    func save(_ config: TranslationProviderConfig) async throws
}

public struct ProviderConfigStoreError: Error {}
