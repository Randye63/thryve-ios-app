import SwiftUI

struct ThryveLayout<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Primary").ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        content
                    }
                    .padding()
                }
            }
        }
    }
} 