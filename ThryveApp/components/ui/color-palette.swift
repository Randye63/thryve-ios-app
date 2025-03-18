import SwiftUI

struct ThryveColors {
    // Brand Colors
    static let primary = Color(hex: "00A86B")
    static let secondary = Color(hex: "00DDEB")
    static let background = Color(hex: "1C2526")
    
    // Text Colors
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.8)
    static let textTertiary = Color.white.opacity(0.6)
    
    // Status Colors
    static let success = Color(hex: "00A86B")
    static let warning = Color(hex: "FFB800")
    static let error = Color(hex: "FF4D4D")
    static let info = Color(hex: "00DDEB")
    
    // Surface Colors
    static let surfacePrimary = Color.white.opacity(0.1)
    static let surfaceSecondary = Color.white.opacity(0.05)
    static let surfaceActive = Color.white.opacity(0.2)
    
    // Gradients
    static let primaryGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "00DDEB"), Color(hex: "00A86B")]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let darkGradient = LinearGradient(
        gradient: Gradient(colors: [background, Color(hex: "151E1F")]),
        startPoint: .top,
        endPoint: .bottom
    )
}

struct ColorPaletteView: View {
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    var body: some View {
        ThryveLayout {
            ScrollView {
                VStack(spacing: 32) {
                    headerSection
                    brandColorsSection
                    textColorsSection
                    statusColorsSection
                    surfaceColorsSection
                    gradientSection
                    usageExamplesSection
                }
                .padding()
            }
        }
        .navigationTitle("Color System")
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Color System")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
            
            Text("Thryve's color palette is designed to create a calm, focused experience")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
        }
    }
    
    private var brandColorsSection: some View {
        ColorSection(title: "Brand Colors") {
            ColorGrid(colors: [
                ColorItem(name: "Primary", hex: "00A86B", color: ThryveColors.primary),
                ColorItem(name: "Secondary", hex: "00DDEB", color: ThryveColors.secondary),
                ColorItem(name: "Background", hex: "1C2526", color: ThryveColors.background)
            ])
        }
    }
    
    private var textColorsSection: some View {
        ColorSection(title: "Typography Colors") {
            ColorGrid(colors: [
                ColorItem(name: "Text Primary", hex: "FFFFFF", color: ThryveColors.textPrimary),
                ColorItem(name: "Text Secondary", hex: "FFFFFF-80", color: ThryveColors.textSecondary),
                ColorItem(name: "Text Tertiary", hex: "FFFFFF-60", color: ThryveColors.textTertiary)
            ])
        }
    }
    
    private var statusColorsSection: some View {
        ColorSection(title: "Status Colors") {
            ColorGrid(colors: [
                ColorItem(name: "Success", hex: "00A86B", color: ThryveColors.success),
                ColorItem(name: "Warning", hex: "FFB800", color: ThryveColors.warning),
                ColorItem(name: "Error", hex: "FF4D4D", color: ThryveColors.error),
                ColorItem(name: "Info", hex: "00DDEB", color: ThryveColors.info)
            ])
        }
    }
    
    private var surfaceColorsSection: some View {
        ColorSection(title: "Surface Colors") {
            ColorGrid(colors: [
                ColorItem(name: "Surface Primary", hex: "FFFFFF-10", color: ThryveColors.surfacePrimary),
                ColorItem(name: "Surface Secondary", hex: "FFFFFF-05", color: ThryveColors.surfaceSecondary),
                ColorItem(name: "Surface Active", hex: "FFFFFF-20", color: ThryveColors.surfaceActive)
            ])
        }
    }
    
    private var gradientSection: some View {
        ColorSection(title: "Gradients") {
            VStack(spacing: 16) {
                GradientCard(
                    name: "Primary Gradient",
                    colors: "#00DDEB → #00A86B",
                    gradient: ThryveColors.primaryGradient
                )
                
                GradientCard(
                    name: "Dark Gradient",
                    colors: "#1C2526 → #151E1F",
                    gradient: ThryveColors.darkGradient
                )
            }
        }
    }
    
    private var usageExamplesSection: some View {
        ColorSection(title: "Usage Examples") {
            VStack(spacing: 16) {
                // Buttons
                ThryveButton("Primary Button", style: .primary) {}
                ThryveButton("Secondary Button", style: .secondary) {}
                
                // Cards
                ThryveCard {
                    Text("Card with surface color")
                        .foregroundColor(.white)
                }
                
                // Status Examples
                HStack(spacing: 16) {
                    StatusPill(text: "Success", color: ThryveColors.success)
                    StatusPill(text: "Warning", color: ThryveColors.warning)
                    StatusPill(text: "Error", color: ThryveColors.error)
                }
            }
        }
    }
}

// Supporting Views
struct ColorSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
            content
        }
    }
}

struct ColorGrid: View {
    let colors: [ColorItem]
    
    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ],
            spacing: 16
        ) {
            ForEach(colors) { color in
                ColorCard(item: color)
            }
        }
    }
}

struct GradientCard: View {
    let name: String
    let colors: String
    let gradient: LinearGradient
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(name)
                .foregroundColor(.white)
            
            Rectangle()
                .fill(gradient)
                .frame(height: 60)
                .cornerRadius(12)
            
            Text(colors)
                .font(.system(size: 14, design: .monospaced))
                .foregroundColor(.white.opacity(0.6))
        }
    }
}

struct StatusPill: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.2))
            .cornerRadius(16)
    }
}

// New Supporting Views
struct ResponsiveSection: View {
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    let title: String
    let colors: [ColorItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(sizeClass == .regular ? .title : .headline)
                .foregroundColor(.white)
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ],
                spacing: 16
            ) {
                ForEach(colors) { item in
                    ColorItemView(item: item)
                }
            }
        }
    }
}

struct ColorItemView: View {
    let item: ColorItem
    
    var body: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(item.color)
                .frame(width: 48, height: 48)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .foregroundColor(.white)
                    .lineLimit(1)
                Text("#\(item.hex)")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

struct ResponsiveGrid<Content: View>: View {
    @Environment(\.horizontalSizeClass) private var sizeClass
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ],
            spacing: 16
        ) {
            content
        }
    }
}

// Add ViewModifier for grid cell sizing
extension View {
    func gridCellColumns(_ columns: Int) -> some View {
        GridCellModifier(columns: columns, content: self)
    }
    
    func gridCellUnsized() -> some View {
        gridCellColumns(-1)
    }
}

struct GridCellModifier<Content: View>: View {
    let columns: Int
    let content: Content
    
    var body: some View {
        if columns == -1 {
            content
        } else {
            content.frame(maxWidth: .infinity)
        }
    }
}

struct ColorItem: Identifiable {
    let id = UUID()
    let name: String
    let hex: String
    let color: Color
}

// Preview
struct ColorPaletteView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPaletteView()
    }
} 
