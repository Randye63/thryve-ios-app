import SwiftUI

struct ProgressBar: View {
    let progress: Double
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.1))
                
                Rectangle()
                    .frame(width: geometry.size.width * progress)
                    .foregroundColor(color)
            }
        }
        .frame(height: 8)
        .cornerRadius(4)
        .animation(.easeInOut, value: progress)
    }
} 