import SwiftUI

struct DismissibleView<Content: View>: View {
    @Environment(\.dismiss) private var dismiss
    let content: Content
    let title: String
    let showsDismissButton: Bool
    
    init(
        title: String = "",
        showsDismissButton: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.showsDismissButton = showsDismissButton
        self.content = content()
    }
    
    var body: some View {
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if showsDismissButton {
                    #if os(macOS)
                    ToolbarItem(placement: .automatic) {
                    #else
                    ToolbarItem(placement: .navigationBarTrailing) {
                    #endif
                        Button("Done") {
                            dismiss()
                        }
                        }
                        .foregroundColor(Color.primary)
                    }
                }
            }
    }
} 