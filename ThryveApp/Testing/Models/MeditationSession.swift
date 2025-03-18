import Foundation

struct MeditationSession: Identifiable {
    let id: UUID
    let date: Date
    let minutes: Int
    let type: MeditationType
    let completed: Bool
    
    enum MeditationType: String, CaseIterable {
        case focus = "Focus"
        case stress = "Stress Relief"
        case sleep = "Sleep"
        case mindfulness = "Mindfulness"
    }
} 