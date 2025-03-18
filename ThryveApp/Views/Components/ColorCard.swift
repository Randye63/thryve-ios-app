import SwiftUI

struct colorCard: View {
    let item: ColorItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Rectangle()
                .fill(item.color)
                .frame(height: 80)
                .cornerRadius(8)
            
            Text(item.name)
                .foregroundColor(.white)
            
            Text("#\(item.hex)")
                .font(.system(size: 14, design: .monospaced))
                .foregroundColor(.white.opacity(0.6))
        }
    }
} 
