import SwiftUI
import FirebaseCore
import FirebaseCoreInternal

@main
struct ThryveApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AIService.shared)
        }
    }
}
