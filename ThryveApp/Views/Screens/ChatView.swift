import SwiftUI

struct ChatView: View {
    @EnvironmentObject private var viewModel: AppViewModel
    @State private var messageText = ""
    @State private var messages: [ChatMessage] = []
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(messages) { message in
                            ChatBubble(message: message)
                        }
                    }
                    .padding()
                }
                
                HStack {
                    TextField("Type a message...", text: $messageText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(isLoading)
                    
                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundColor(messageText.isEmpty ? .gray : .blue)
                    }
                    .disabled(messageText.isEmpty || isLoading)
                }
                .padding()
            }
            .navigationTitle("AI Assistant")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: clearChat) {
                        Image(systemName: "trash")
                    }
                }
            }
        }
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        let userMessage = ChatMessage(
            id: UUID(),
            text: messageText,
            isUser: true,
            timestamp: Date()
        )
        messages.append(userMessage)
        
        let currentText = messageText
        messageText = ""
        isLoading = true
        
        // Simulate AI response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let response = generateAIResponse(to: currentText)
            let aiMessage = ChatMessage(
                id: UUID(),
                text: response,
                isUser: false,
                timestamp: Date()
            )
            messages.append(aiMessage)
            isLoading = false
        }
    }
    
    private func clearChat() {
        messages.removeAll()
    }
    
    private func generateAIResponse(to message: String) -> String {
        // Simple response generation based on keywords
        let lowercased = message.lowercased()
        
        if lowercased.contains("task") || lowercased.contains("todo") {
            return "I can help you organize your tasks. Would you like to create a new task or view your existing ones?"
        } else if lowercased.contains("focus") || lowercased.contains("break") {
            return "Taking regular breaks is important for productivity. I can help you schedule a mindful break or focus session."
        } else if lowercased.contains("resume") || lowercased.contains("job") {
            return "I can help you improve your resume and job applications. Would you like to get some suggestions for your skills or job search strategy?"
        } else if lowercased.contains("habit") {
            return "Building good habits takes time and consistency. I can help you track your habits and set up reminders."
        } else {
            return "I'm here to help you stay organized and productive. You can ask me about tasks, focus sessions, job applications, or habits."
        }
    }
}

struct ChatMessage: Identifiable {
    let id: UUID
    let text: String
    let isUser: Bool
    let timestamp: Date
}

struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            Text(message.text)
                .padding()
                .background(message.isUser ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(message.isUser ? .white : .primary)
                .cornerRadius(16)
            
            if !message.isUser { Spacer() }
        }
    }
}

#Preview {
    ChatView()
        .environmentObject(AppViewModel())
} 