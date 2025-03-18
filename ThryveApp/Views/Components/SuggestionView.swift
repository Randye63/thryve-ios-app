import SwiftUI

struct SuggestionView: View {
    @EnvironmentObject private var aiService: AIService
    @Binding var isPresented: Bool
    @State private var suggestion: String?
    
    var body: some View {
        VStack(spacing: 16) {
            if aiService.isLoading {
                ProgressView()
                    .tint(.white)
            } else if let suggestion = suggestion {
                Text("Suggestion: \(suggestion)")
                    .foregroundColor(.white)
                    .padding()
            } else if let error = aiService.error {
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button("OK") { isPresented = false }
                .buttonStyle(ThryveButtonStyle())
                .padding()
        }
        .frame(maxWidth: .infinity)
        .background(ThryveColors.background)
        .task {
            do {
                suggestion = try await aiService.getResumeSuggestions()
            } catch {
                aiService.error = error
            }
        }
    }
} 