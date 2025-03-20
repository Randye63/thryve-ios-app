import SwiftUI

struct ThryveCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(Color("Secondary").opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal)
    }
} 