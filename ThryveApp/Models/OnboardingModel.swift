import Foundation

enum OnboardingStep: Equatable {
    case welcomeSelection
    case focusSelection
    case motivationalMessage
    case loginSignUp
}

struct OnboardingData {
    var selectedFocusAreas: Set<String>
    var motivationalMessage: String
    var isLoggedIn: Bool
    
    static let defaultFocusAreas = [
        "Work",
        "Personal",
        "Health",
        "Learning",
        "Social"
    ]
}

class OnboardingViewModel: ObservableObject {
    @Published var currentStep: OnboardingStep = .welcomeSelection
    @Published var onboardingData = OnboardingData(
        selectedFocusAreas: [],
        motivationalMessage: "",
        isLoggedIn: false
    )
    
    func nextStep() {
        switch currentStep {
        case .welcomeSelection:
            currentStep = .focusSelection
        case .focusSelection:
            currentStep = .motivationalMessage
        case .motivationalMessage:
            currentStep = .loginSignUp
        case .loginSignUp:
            // Onboarding complete
            break
        }
    }
    
    func previousStep() {
        switch currentStep {
        case .welcomeSelection:
            // Already at first step
            break
        case .focusSelection:
            currentStep = .welcomeSelection
        case .motivationalMessage:
            currentStep = .focusSelection
        case .loginSignUp:
            currentStep = .motivationalMessage
        }
    }
    
    func completeOnboarding() {
        onboardingData.isLoggedIn = true
    }
}
