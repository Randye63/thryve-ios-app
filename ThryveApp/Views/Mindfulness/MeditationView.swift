import SwiftUI

struct MeditationView: View {
    @State private var isPlaying = false
    @StateObject private var mindfulnessService = MindfulnessService.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "1C2526").ignoresSafeArea()
                VStack(spacing: 16) {
                    Text("Meditations")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    ForEach(mindfulnessService.meditations, id: \.self) { meditation in
                        MeditationCard(
                            title: meditation,
                            isPlaying: isPlaying,
                            onTap: { isPlaying.toggle() }
                        )
                    }
                    
                    Text(isPlaying ? "Playing..." : "Tap to start")
                        .foregroundColor(.white.opacity(0.6))
                        .animation(.easeInOut, value: isPlaying)
                }
                .padding()
            }
            .navigationTitle("Meditations")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MeditationCard: View {
    let title: String
    let isPlaying: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(title)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .foregroundColor(Color(hex: "00A86B"))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
        }
        .padding(.horizontal, 16)
    }
} 