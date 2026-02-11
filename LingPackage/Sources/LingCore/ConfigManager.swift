import Foundation

public final class ConfigManager {
    public static let shared = ConfigManager()
    
    private let userDefaults: UserDefaults?
    
    private init() {
        self.userDefaults = UserDefaults(suiteName: LingConstants.appGroupId)
    }
    
    /// Saves the config metadata to UserDefaults and the API key to Keychain.
    public func saveConfig(_ config: TranslationProviderConfig) throws {
        // 1. Save API Key to Keychain
        try KeychainManager.shared.save(key: LingConstants.KeychainKeys.apiKey, value: config.apiKey)
        
        // 2. Prepare a version of config without the API key for UserDefaults (security best practice)
        var sanitizedConfig = config
        sanitizedConfig.apiKey = "" // Clear it for UserDefaults
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(sanitizedConfig)
        userDefaults?.set(data, forKey: LingConstants.UserDefaultsKeys.providerConfig)
    }
    
    /// Loads the config from UserDefaults and populates the API key from Keychain.
    public func loadConfig() -> TranslationProviderConfig? {
        guard let data = userDefaults?.data(forKey: LingConstants.UserDefaultsKeys.providerConfig) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            var config = try decoder.decode(TranslationProviderConfig.self, from: data)
            
            // Try to load API Key from Keychain
            if let apiKey = try? KeychainManager.shared.retrieve(key: LingConstants.KeychainKeys.apiKey) {
                config.apiKey = apiKey
            }
            
            return config
        } catch {
            print("Failed to load config: \(error)")
            return nil
        }
    }
    
    public func deleteConfig() {
        userDefaults?.removeObject(forKey: LingConstants.UserDefaultsKeys.providerConfig)
        try? KeychainManager.shared.delete(key: LingConstants.KeychainKeys.apiKey)
    }
}
