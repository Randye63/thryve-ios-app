import SwiftUI

struct DismissAction: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    let edge: Edge
    
    init(edge: Edge = .trailing) {
        self.edge = edge
    }
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: edge == .leading ? .cancellationAction : .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color.blue) // Assuming ThryveColors.primary is blue
                }
            }
    }
}

extension View {
    func addDismissButton(edge: Edge = .trailing) -> some View {
        modifier(DismissAction(edge: edge))
    }
} 