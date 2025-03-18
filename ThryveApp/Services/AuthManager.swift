import Foundation
import FirebaseAuth

class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var userEmail: String?
    
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isAuthenticated = user != nil
            self?.userEmail = user?.email
        }
    }
    
    func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
} 