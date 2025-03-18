import SwiftUI
import CoreData

struct ThryveProviders<Content: View>: View {
    let content: Content
    @StateObject private var aiService = AIService.shared
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            .environmentObject(aiService)
    }
} 