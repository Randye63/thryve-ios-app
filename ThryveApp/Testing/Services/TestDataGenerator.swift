import Foundation

class TestDataGenerator {
    static let shared = TestDataGenerator()
    
    // Generate last 7 days of meditation data
    func generateWeeklyMeditations() -> [MeditationSession] {
        let calendar = Calendar.current
        let today = Date()
        
        return (0..<7).map { daysAgo in
            guard let date = calendar.date(
                byAdding: .day,
                value: -daysAgo,
                to: today
            ) else {
                fatalError("Invalid date calculation")
            }
            
            return MeditationSession(
                id: UUID(),
                date: date,
                minutes: Int.random(in: 5...30),
                type: MeditationType.allCases.randomElement() ?? .mindfulness,
                completed: Bool.random()
            )
        }.reversed() // Order from oldest to newest
    }
    
    // Generate realistic test data
    func generateRealisticWeeklyMeditations() -> [MeditationSession] {
        let calendar = Calendar.current
        let today = Date()
        
        return (0..<7).map { daysAgo in
            guard let date = calendar.date(
                byAdding: .day,
                value: -daysAgo,
                to: today
            ) else {
                fatalError("Invalid date calculation")
            }
            
            // More realistic patterns:
            // - Higher completion rate on weekdays
            // - Longer sessions in morning/evening
            // - Gradual increase in duration
            let isWeekday = calendar.isDateInWeekend(date)
            let baseMinutes = daysAgo < 3 ? 15 : 10 // Recent sessions longer
            let variability = Int.random(in: -5...5)
            
            return MeditationSession(
                id: UUID(),
                date: date,
                minutes: max(5, baseMinutes + variability),
                type: isWeekday ? .focus : .stress,
                completed: isWeekday ? true : Bool.random()
            )
        }.reversed()
    }
} 