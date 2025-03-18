# Thryve iOS App

A wellness and productivity iOS app built with Swift and SwiftUI, featuring task management, habit tracking, mindfulness, job application support, and AI-driven suggestions.

## Features (Version 1.0)
- Auto-organizes calendar and tasks with Core Data
- Customizable focus areas: My Day, Progress, Activities, Jobs, Chat, Profile
- Micro-reset moments for mindfulness (e.g., 60-second breaks)
- Basic AI-driven resume suggestions
- Persistent data storage and local notifications
- Firebase Authentication integration
- Swift Charts for progress visualization

## Requirements
- iOS 16.0+
- Xcode 14.0+
- Swift 5.7+
- CocoaPods

## Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/Randye63/thryve-ios-app.git
   cd thryve-ios-app
   ```

2. Install dependencies:
   ```bash
   pod install
   ```

3. Configure Firebase:
   - Download `GoogleService-Info.plist` from Firebase Console
   - Add it to the project root
   - Enable Authentication in Firebase Console

4. Open the workspace:
   ```bash
   open ThryveApp.xcworkspace
   ```

## Project Structure
```
/App
├── ThryveApp.swift          # Main app entry point
└── AppDelegate.swift        # Firebase initialization

/Core
├── /Models
│   ├── Task.swift           # Task and todo models
│   ├── FocusSession.swift   # Focus session models
│   ├── JobApplication.swift # Job application tracking
│   └── OnboardingModel.swift # Onboarding flow
├── /Services
│   ├── CoreDataManager.swift    # Core Data operations
│   ├── NotificationService.swift # Local notifications
│   ├── AuthManager.swift        # Firebase Authentication
│   └── MindfulnessService.swift # Mindfulness content
└── /Managers
    └── AppViewModel.swift       # MVVM coordinator

/Views
├── /Common
│   └── ButtonStyle.swift    # Reusable button styles
├── /Auth
│   ├── OnboardingView.swift # Onboarding flow
│   └── LoginSignUpScreen.swift # Authentication UI
├── /Home
│   └── MyDayView.swift      # Dashboard
├── /FocusAreas
│   ├── HabitsView.swift     # Habit tracking
│   ├── JobsView.swift       # Job applications
│   ├── ProgressView.swift   # Progress charts
│   ├── ProfileView.swift    # User settings
│   └── ChatView.swift       # AI chat assistant
└── /Mindfulness
    ├── MeditationView.swift # Guided meditations
    └── MicroResetView.swift # Micro-reset UI

/Assets
├── Assets.xcassets         # App assets
└── Colors.swift           # Color palette

/Utilities
├── NetworkUtils.swift     # Networking layer (v2.0)
└── DateUtils.swift        # Date formatting

/Tests
├── /UnitTests
│   ├── CoreDataManagerTests.swift
│   └── AuthManagerTests.swift
└── /UITests
    ├── OnboardingUITests.swift
    └── LoginUITests.swift
```

## Design System
- Primary Colors: Green-Blue gradient (#00DDEB to #00A86B)
- Background: Dark gray (#1C2526)
- Text: White
- Button Radius: 16px
- Card Radius: 12px
- Animations: 0.3s duration

## Version 2.0 Roadmap
- Email integration (Gmail/Outlook)
- Text message integration
- Advanced AI resume suggestions
- Job application automation
- Enhanced mindfulness content
- Data sync across devices

## Contributing
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments
- Firebase for authentication and backend services
- SwiftUI for the modern UI framework
- Core Data for persistent storage
- Swift Charts for data visualization