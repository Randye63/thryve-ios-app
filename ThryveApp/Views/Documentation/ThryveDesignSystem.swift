import SwiftUI

struct ThryveDesignSystem: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                headerSection
                colorSection
                typographySection
                spacingSection
                componentsSection
            }
            .padding(24)
        }
        .background(ThryveColors.background)
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Thryve Design System")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
            
            Text("A comprehensive guide to Thryve's visual language")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
        }
    }
    
    private var colorSection: some View {
        DesignSection(title: "Color System") {
            VStack(alignment: .leading, spacing: 24) {
                // Primary Gradient
                VStack(alignment: .leading, spacing: 8) {
                    Text("Primary Gradient")
                        .foregroundColor(.white)
                    
                    Rectangle()
                        .fill(ThryveColors.primaryGradient)
                        .frame(height: 60)
                        .cornerRadius(12)
                        .overlay(
                            Text("#00DDEB → #00A86B")
                                .font(.system(size: 14, design: .monospaced))
                                .foregroundColor(.white)
                        )
                }
                
                // Colors Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ColorCard(name: "Background", hex: "1C2526", color: ThryveColors.background)
                    ColorCard(name: "Primary", hex: "00A86B", color: ThryveColors.primary)
                    ColorCard(name: "Secondary", hex: "00DDEB", color: ThryveColors.secondary)
                    ColorCard(name: "Text Primary", hex: "FFFFFF", color: .white)
                }
            }
        }
    }
    
    private var typographySection: some View {
        DesignSection(title: "Typography") {
            VStack(alignment: .leading, spacing: 24) {
                TypeStyle(name: "Title", size: "32pt") {
                    Text("Title Example")
                        .font(.system(size: 32, weight: .bold))
                }
                
                TypeStyle(name: "Heading", size: "24pt") {
                    Text("Heading Example")
                        .font(.system(size: 24, weight: .semibold))
                }
                
                TypeStyle(name: "Body", size: "16pt") {
                    Text("Body text example")
                        .font(.system(size: 16))
                }
                
                TypeStyle(name: "Caption", size: "14pt") {
                    Text("Caption text example")
                        .font(.system(size: 14))
                }
            }
        }
    }
    
    private var spacingSection: some View {
        DesignSection(title: "Spacing System") {
            VStack(alignment: .leading, spacing: 16) {
                ForEach([8, 16, 24, 32], id: \.self) { space in
                    SpacingExample(size: space)
                }
            }
        }
    }
    
    private var componentsSection: some View {
        DesignSection(title: "Components") {
            VStack(alignment: .leading, spacing: 24) {
                // Buttons
                ComponentGroup(title: "Buttons") {
                    VStack(spacing: 16) {
                        ThryveButton("Primary Button", style: .primary) {}
                        ThryveButton("Secondary Button", style: .secondary) {}
                        ThryveButton("Gradient Button", style: .gradient) {}
                    }
                }
                
                // Cards
                ComponentGroup(title: "Cards") {
                    ThryveCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Card Title")
                                .font(.headline)
                            Text("Card content example with supporting text")
                                .font(.subheadline)
                        }
                        .foregroundColor(.white)
                    }
                }
                
                // Form Elements
                ComponentGroup(title: "Form Elements") {
                    ThryveInput(placeholder: "Text Input", text: .constant(""))
                }
            }
        }
    }
}

// Supporting Views
struct DesignSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            content
        }
    }
}

struct ColorCard: View {
    let name: String
    let hex: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Rectangle()
                .fill(color)
                .frame(height: 80)
                .cornerRadius(8)
            
            Text(name)
                .foregroundColor(.white)
            
            Text("#\(hex)")
                .font(.system(size: 14, design: .monospaced))
                .foregroundColor(.white.opacity(0.6))
        }
    }
}

struct TypeStyle<Content: View>: View {
    let name: String
    let size: String
    let content: Content
    
    init(name: String, size: String, @ViewBuilder content: () -> Content) {
        self.name = name
        self.size = size
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            content
                .foregroundColor(.white)
            
            Text("\(name) - \(size)")
                .font(.system(size: 14, design: .monospaced))
                .foregroundColor(.white.opacity(0.6))
        }
    }
}

struct SpacingExample: View {
    let size: CGFloat
    
    var body: some View {
        HStack {
            Text("\(Int(size))pt")
                .font(.system(size: 14, design: .monospaced))
                .foregroundColor(.white)
                .frame(width: 60, alignment: .leading)
            
            Rectangle()
                .fill(ThryveColors.primary.opacity(0.3))
                .frame(width: size, height: 32)
        }
    }
}

struct ComponentGroup<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            content
        }
    }
}

// Preview
struct ThryveDesignSystem_Previews: PreviewProvider {
    static var previews: some View {
        ThryveDesignSystem()
    }
} 