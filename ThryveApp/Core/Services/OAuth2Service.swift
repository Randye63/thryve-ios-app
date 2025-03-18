import Foundation
import AuthenticationServices

enum OAuthProvider {
    case gmail
    case outlook
}

class OAuth2Service: NSObject, ASWebAuthenticationPresentationContextProviding {
    static let shared = OAuth2Service()
    
    private var completionHandler: ((Result<String, Error>) -> Void)?
    
    // Replace these with your actual OAuth credentials
    private let gmailClientId = "YOUR_GMAIL_CLIENT_ID"
    private let gmailRedirectUri = "com.thryveapp://oauth2callback/gmail"
    private let outlookClientId = "YOUR_OUTLOOK_CLIENT_ID"
    private let outlookRedirectUri = "com.thryveapp://oauth2callback/outlook"
    
    private override init() {
        super.init()
    }
    
    func authenticate(provider: OAuthProvider) async throws -> String {
        let (clientId, redirectUri, scope) = {
            switch provider {
            case .gmail:
                return (gmailClientId, gmailRedirectUri, "https://www.googleapis.com/auth/gmail.readonly")
            case .outlook:
                return (outlookClientId, outlookRedirectUri, "offline_access Mail.Read")
            }
        }()
        
        let authURL = {
            switch provider {
            case .gmail:
                return "https://accounts.google.com/o/oauth2/v2/auth?client_id=\(clientId)&redirect_uri=\(redirectUri)&response_type=code&scope=\(scope)&access_type=offline"
            case .outlook:
                return "https://login.microsoftonline.com/common/oauth2/v2.0/authorize?client_id=\(clientId)&redirect_uri=\(redirectUri)&response_type=code&scope=\(scope)"
            }
        }()
        
        return try await withCheckedThrowingContinuation { continuation in
            self.completionHandler = { result in
                continuation.resume(with: result)
            }
            
            let session = ASWebAuthenticationSession(
                url: URL(string: authURL)!,
                callbackURLScheme: "com.thryveapp",
                completionHandler: { [weak self] callbackURL, error in
                    if let error = error {
                        self?.completionHandler?(.failure(error))
                        return
                    }
                    
                    guard let callbackURL = callbackURL,
                          let code = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false)?
                            .queryItems?
                            .first(where: { $0.name == "code" })?
                            .value else {
                        self?.completionHandler?(.failure(NSError(domain: "OAuth2Service", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get authorization code"])))
                        return
                    }
                    
                    self?.completionHandler?(.success(code))
                }
            )
            
            session.presentationContextProvider = self
            session.start()
        }
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        UIApplication.shared.windows.first ?? ASPresentationAnchor()
    }
    
    func exchangeCodeForToken(code: String, provider: OAuthProvider) async throws -> String {
        let (clientId, clientSecret, redirectUri, tokenURL) = {
            switch provider {
            case .gmail:
                return (gmailClientId, "YOUR_GMAIL_CLIENT_SECRET", gmailRedirectUri, "https://oauth2.googleapis.com/token")
            case .outlook:
                return (outlookClientId, "YOUR_OUTLOOK_CLIENT_SECRET", outlookRedirectUri, "https://login.microsoftonline.com/common/oauth2/v2.0/token")
            }
        }()
        
        var request = URLRequest(url: URL(string: tokenURL)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let body = "client_id=\(clientId)&client_secret=\(clientSecret)&code=\(code)&redirect_uri=\(redirectUri)&grant_type=authorization_code"
        request.httpBody = body.data(using: .utf8)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(OAuthTokenResponse.self, from: data)
        return response.access_token
    }
}

struct OAuthTokenResponse: Codable {
    let access_token: String
    let refresh_token: String?
    let expires_in: Int
    let token_type: String
} 