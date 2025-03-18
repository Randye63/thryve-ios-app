import SwiftUI

struct MicroResetView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var mindfulnessService = MindfulnessService.shared
    @State private var timeLeft = 60
    @State private var isRunning = false
    @State private var breatheIn = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color(hex: "1C2526").ignoresSafeArea()
            VStack(spacing: 16) {
                Text("Micro Reset")
                    .font(.title)
                    .foregroundColor(.white)
                
                Text(mindfulnessService.getMicroResetPrompt())
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                
                Text("\(timeLeft) seconds")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)
                
                Circle()
                    .stroke(Color(hex: "00A86B"), lineWidth: 4)
                    .frame(width: 100, height: 100)
                    .scaleEffect(breatheIn ? 1.2 : 0.8)
                    .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: breatheIn)
                    .onAppear { breatheIn = true }
                
                Button(action: toggleTimer) {
                    Text(isRunning ? "Stop" : "Start")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "00DDEB"), Color(hex: "00A86B")]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                }
                .padding(.horizontal, 16)
            }
            .padding()
            .onReceive(timer) { _ in
                updateTimer()
            }
        }
    }
    
    private func toggleTimer() {
        isRunning.toggle()
        if !isRunning && timeLeft < 60 {
            timeLeft = 60
        }
    }
    
    private func updateTimer() {
        guard isRunning else { return }
        
        if timeLeft > 0 {
            timeLeft -= 1
        } else {
            isRunning = false
            timeLeft = 60
            dismiss()
        }
    }
} 