import Foundation

public enum LingConstants {
    /// Update this with your actual App Group ID from Apple Developer Portal
    public static let appGroupId = "group.com.mingchen.ling"
    
    public enum KeychainKeys {
        public static let apiKey = "ling.api.key"
    }
    
    public enum UserDefaultsKeys {
        public static let providerConfig = "ling.provider.config"
    }
}
