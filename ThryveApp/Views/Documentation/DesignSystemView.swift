import SwiftUI

// Add error handling wrapper
struct ErrorHandlingView<Content: View>: View {
    let content: Content
    @State private var error: Error?
    @State private var showError = false
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            content
                .onAppear {
                    // Reset error state on view appear
                    error = nil
                    showError = false
                }
            
            if showError, let error = error {
                ErrorOverlay(error: error) {
                    showError = false
                }
            }
        }
    }
    
    func handleError(_ error: Error) {
        self.error = error
        showError = true
    }
}

// Add error overlay
struct ErrorOverlay: View {
    let error: Error
    let dismiss: () -> Void
    
    var body: some View {
        VStack {
            Text("Error")
                .font(.headline)
                .foregroundColor(.white)
            
            Text(error.localizedDescription)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Dismiss") {
                dismiss()
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.red.opacity(0.3))
            .cornerRadius(8)
        }
        .padding()
        .background(Color.black.opacity(0.8))
        .cornerRadius(12)
        .padding()
    }
}

// Update main view with error handling
struct DesignSystemView: View {
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var loadingError: Error?
    
    var body: some View {
        ErrorHandlingView {
            ThryveLayout {
                ScrollView {
                    VStack(spacing: 32) {
                        headerSection
                        
                        // Wrap sections that might fail in try/catch
                        Group {
                            do {
                                try colorSection
                                try typographySection
                                try spacingSection
                                try componentSection
                            } catch {
                                handleError(error)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Design System")
    }
    
    private func handleError(_ error: Error) {
        loadingError = error
        print("Design System Error: \(error.localizedDescription)")
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Thryve Design System")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
            
            Text("A comprehensive guide to Thryve's visual language and component library")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
        }
    }
    
    private var colorSection: some View {
        DocSection(title: "Colors") {
            VStack(alignment: .leading, spacing: 24) {
                // Primary Colors
                ColorRow(title: "Primary", colors: [
                    ("Primary", "00A86B"),
                    ("Secondary", "00DDEB"),
                    ("Background", "1C2526")
                ])
                
                // Text Colors
                ColorRow(title: "Typography", colors: [
                    ("Text Primary", "FFFFFF"),
                    ("Text Secondary", "FFFFFF-80"),
                    ("Text Tertiary", "FFFFFF-60")
                ])
                
                // Gradient Example
                VStack(alignment: .leading, spacing: 8) {
                    Text("Primary Gradient")
                        .foregroundColor(.white)
                    
                    Rectangle()
                        .fill(ThryveColors.primaryGradient)
                        .frame(height: 60)
                        .cornerRadius(12)
                }
            }
        }
    }
    
    private var typographySection: some View {
        DocSection(title: "Typography") {
            VStack(alignment: .leading, spacing: 24) {
                TypeRow(name: "Title", size: "32pt", weight: "Bold") {
                    Text("Sample Title")
                        .font(.system(size: 32, weight: .bold))
                }
                
                TypeRow(name: "Heading", size: "24pt", weight: "Semibold") {
                    Text("Sample Heading")
                        .font(.system(size: 24, weight: .semibold))
                }
                
                TypeRow(name: "Body", size: "16pt", weight: "Regular") {
                    Text("Sample Body Text")
                        .font(.system(size: 16))
                }
                
                TypeRow(name: "Caption", size: "14pt", weight: "Regular") {
                    Text("Sample Caption")
                        .font(.system(size: 14))
                }
            }
        }
    }
    
    private var spacingSection: some View {
        DocSection(title: "Spacing System") {
            VStack(alignment: .leading, spacing: 24) {
                SpacingRow(name: "XS", size: 4)
                SpacingRow(name: "Small", size: 8)
                SpacingRow(name: "Medium", size: 16)
                SpacingRow(name: "Large", size: 24)
                SpacingRow(name: "XL", size: 32)
            }
        }
    }
    
    private var componentSection: some View {
        DocSection(title: "Components") {
            VStack(alignment: .leading, spacing: 24) {
                // Buttons
                ComponentRow(title: "Buttons") {
                    VStack(spacing: 16) {
                        ThryveButton("Primary Button") {}
                        ThryveButton("Secondary Button", style: .secondary) {}
                        ThryveButton("Gradient Button", style: .gradient) {}
                    }
                }
                
                // Cards
                ComponentRow(title: "Cards") {
                    ThryveCard {
                        Text("Card Content")
                            .foregroundColor(.white)
                    }
                }
                
                // Inputs
                ComponentRow(title: "Inputs") {
                    ThryveInput(placeholder: "Sample Input", text: .constant(""))
                }
            }
        }
    }
}

// Supporting Views
struct DocSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            content
        }
    }
}

struct ColorRow: View {
    let title: String
    let colors: [(name: String, hex: String)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(.white.opacity(0.8))
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(colors, id: \.name) { color in
                    ColorSwatch(name: color.name, hex: color.hex)
                }
            }
        }
    }
}

struct ColorSwatch: View {
    let name: String
    let hex: String
    @State private var isValid = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if isValid {
                Rectangle()
                    .fill(Color(hex: hex))
                    .frame(height: 60)
                    .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 60)
                    .cornerRadius(8)
                    .overlay(
                        Text("Invalid Color")
                            .foregroundColor(.white)
                            .font(.caption)
                    )
            }
            
            Text(name)
                .font(.system(size: 14))
                .foregroundColor(.white)
            
            Text("#\(hex)")
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(.white.opacity(0.6))
        }
        .onAppear {
            validateColor()
        }
    }
    
    private func validateColor() {
        do {
            _ = try Color.validateHex(hex)
            isValid = true
        } catch {
            isValid = false
        }
    }
}

struct TypeRow<Content: View>: View {
    let name: String
    let size: String
    let weight: String
    let content: Content
    
    init(name: String, size: String, weight: String, @ViewBuilder content: () -> Content) {
        self.name = name
        self.size = size
        self.weight = weight
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            content
                .foregroundColor(.white)
            
            Text("\(name) - \(size) - \(weight)")
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(.white.opacity(0.6))
        }
    }
}

struct SpacingRow: View {
    let name: String
    let size: CGFloat
    
    var body: some View {
        HStack(spacing: 16) {
            Text(name)
                .foregroundColor(.white)
                .frame(width: 80, alignment: .leading)
            
            Rectangle()
                .fill(Color.white.opacity(0.2))
                .frame(width: size, height: 24)
            
            Text("\(Int(size))pt")
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(.white.opacity(0.6))
        }
    }
}

struct ComponentRow<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(.white.opacity(0.8))
            
            content
        }
    }
}

// Add result checking for color hex values
extension Color {
    init(hex: String) {
        do {
            let hex = try Self.validateHex(hex)
            self.init(hex: hex)
        } catch {
            print("Invalid hex color: \(hex)")
            self.init(.gray) // Fallback color
        }
    }
    
    private static func validateHex(_ hex: String) throws -> String {
        let pattern = "^[0-9A-Fa-f]{6}$"
        guard hex.range(of: pattern, options: .regularExpression) != nil else {
            throw ColorError.invalidHex(hex)
        }
        return hex
    }
}

enum ColorError: LocalizedError {
    case invalidHex(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidHex(let hex):
            return "Invalid hex color code: \(hex)"
        }
    }
} 