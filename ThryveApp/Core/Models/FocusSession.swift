import Foundation

struct FocusSession: Identifiable, Codable {
    let id: UUID
    var title: String
    var duration: TimeInterval
    var type: SessionType
    var scheduledTime: Date?
    var isCompleted: Bool
    var notes: String?
    
    init(id: UUID = UUID(), title: String, duration: TimeInterval, type: SessionType, scheduledTime: Date? = nil, isCompleted: Bool = false, notes: String? = nil) {
        self.id = id
        self.title = title
        self.duration = duration
        self.type = type
        self.scheduledTime = scheduledTime
        self.isCompleted = isCompleted
        self.notes = notes
    }
}

enum SessionType: String, Codable {
    case mindfulBreak = "Mindful Break"
    case focusSession = "Focus Session"
    case quickReset = "Quick Reset"
} 