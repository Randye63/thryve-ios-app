import Foundation

struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var dueDate: Date
    var priority: Priority
    var category: Category
    var isCompleted: Bool
    var source: TaskSource
    
    init(id: UUID = UUID(), title: String, description: String, dueDate: Date, priority: Priority = .medium, category: Category, isCompleted: Bool = false, source: TaskSource) {
        self.id = id
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.priority = priority
        self.category = category
        self.isCompleted = isCompleted
        self.source = source
    }
}

enum Priority: String, Codable {
    case low, medium, high
}

enum Category: String, Codable, CaseIterable {
    case work, personal, habits, jobs
}

enum TaskSource: String, Codable {
    case email, text, manual, calendar
} 