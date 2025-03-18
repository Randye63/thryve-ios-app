import Foundation

class MindfulnessService: ObservableObject {
    static let shared = MindfulnessService()
    
    let meditations = [
        "Morning Meditation",
        "Stress Relief",
        "Focus Boost",
        "Sleep Aid",
        "Anxiety Relief"
    ]
    
    private let microResetPrompts = [
        "Take a deep breath in... and out...",
        "Feel your body relax with each breath",
        "Let go of any tension you're holding",
        "Center yourself in this moment",
        "Busy morning? Take 60 seconds to breathe",
        "Feeling stressed? Try a quick reset"
    ]
    
    func getMicroResetPrompt() -> String {
        microResetPrompts.randomElement() ?? "Take a moment to breathe"
    }
    
    private init() {} // Ensure singleton pattern
} 