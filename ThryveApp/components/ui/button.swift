import SwiftUI

struct ThryveButton: View {
    let title: String
    let action: () -> Void
    @State private var isPressed = false
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 14))
                    .padding(.leading, 8)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color("Primary"),
                        Color("Secondary")
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16) // rounded-2xl equivalent
            .opacity(isPressed ? 0.9 : 1.0) // hover:opacity-90 equivalent
            .animation(.easeInOut(duration: 0.2), value: isPressed)
        }
        .buttonStyle(PressableButtonStyle())
    }
}

// Custom button style to handle press state
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

// Usage example
struct ButtonPreview: View {
    var body: some View {
        ThryveButton("Get Started") {
            print("Button tapped")
        }
        .padding()
    }
}

// Preview
struct ThryveButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("Primary").ignoresSafeArea()
            ButtonPreview()
        }
    }
} 