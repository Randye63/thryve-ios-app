struct APIConfig {
    static let v0APIKey = "your_v0_api_key_here"
    static let provider = "v0"
    
    // Don't commit the actual API key to source control
    static var isConfigured: Bool {
        return v0APIKey != "your_v0_api_key_here"
    }
} 