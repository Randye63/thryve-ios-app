import Foundation

protocol EmailServiceProtocol {
    func authenticate() async throws
    func fetchEmails() async throws -> [Task]
    func markEmailAsProcessed(_ emailId: String) async throws
}

class EmailService: EmailServiceProtocol {
    private var isAuthenticated = false
    private var accessToken: String?
    private let oauth2Service = OAuth2Service.shared
    
    func authenticate() async throws {
        // Try Gmail first, fall back to Outlook if needed
        do {
            let code = try await oauth2Service.authenticate(provider: .gmail)
            accessToken = try await oauth2Service.exchangeCodeForToken(code: code, provider: .gmail)
            isAuthenticated = true
        } catch {
            // If Gmail fails, try Outlook
            let code = try await oauth2Service.authenticate(provider: .outlook)
            accessToken = try await oauth2Service.exchangeCodeForToken(code: code, provider: .outlook)
            isAuthenticated = true
        }
    }
    
    func fetchEmails() async throws -> [Task] {
        guard isAuthenticated, let accessToken = accessToken else {
            throw EmailError.notAuthenticated
        }
        
        // Fetch emails from Gmail API
        var request = URLRequest(url: URL(string: "https://gmail.googleapis.com/gmail/v1/users/me/messages?maxResults=10")!)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(GmailListResponse.self, from: data)
        
        var tasks: [Task] = []
        
        for message in response.messages {
            let email = try await fetchEmailDetails(messageId: message.id, accessToken: accessToken)
            if let task = convertEmailToTask(email) {
                tasks.append(task)
            }
        }
        
        return tasks
    }
    
    private func fetchEmailDetails(messageId: String, accessToken: String) async throws -> Email {
        var request = URLRequest(url: URL(string: "https://gmail.googleapis.com/gmail/v1/users/me/messages/\(messageId)")!)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(Email.self, from: data)
    }
    
    private func convertEmailToTask(_ email: Email) -> Task? {
        // Extract relevant information from email
        guard let subject = email.payload.headers.first(where: { $0.name == "Subject" })?.value,
              let dateString = email.payload.headers.first(where: { $0.name == "Date" })?.value,
              let date = parseEmailDate(dateString) else {
            return nil
        }
        
        return Task(
            title: subject,
            description: "Email from: \(email.payload.headers.first(where: { $0.name == "From" })?.value ?? "Unknown")",
            dueDate: date,
            priority: .medium,
            category: .work,
            source: .email
        )
    }
    
    private func parseEmailDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        return formatter.date(from: dateString)
    }
    
    func markEmailAsProcessed(_ emailId: String) async throws {
        guard isAuthenticated, let accessToken = accessToken else {
            throw EmailError.notAuthenticated
        }
        
        // Implement marking email as processed (e.g., adding a label)
        // This is a placeholder for actual implementation
    }
}

enum EmailError: Error {
    case notAuthenticated
    case fetchFailed
    case processingFailed
}

struct GmailListResponse: Codable {
    let messages: [GmailMessage]
}

struct GmailMessage: Codable {
    let id: String
}

struct Email: Codable {
    let id: String
    let payload: EmailPayload
}

struct EmailPayload: Codable {
    let headers: [EmailHeader]
}

struct EmailHeader: Codable {
    let name: String
    let value: String
} 