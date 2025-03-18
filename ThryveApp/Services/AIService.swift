import SwiftUI
import Combine

class AIService: ObservableObject {
    static let shared = AIService()
    
    @Published var isLoading = false
    @Published var error: Error?
    
    private init() {}
    
    func getResumeSuggestions() async throws -> String {
        isLoading = true
        defer { isLoading = false }
        
        // Simulate API call
        try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        return "Add React and SwiftUI to your skills section"
    }
}

enum AIError: Error {
    case notConfigured
    case invalidResponse
    case networkError(Error)
} 