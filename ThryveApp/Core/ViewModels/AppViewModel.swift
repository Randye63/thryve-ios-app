import Foundation
import SwiftUI

@MainActor
class AppViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var focusSessions: [FocusSession] = []
    @Published var selectedTab: Category = .work
    @Published var isLoading = false
    @Published var error: Error?
    
    private let emailService: EmailServiceProtocol
    private let coreDataManager = CoreDataManager.shared
    
    init(emailService: EmailServiceProtocol = EmailService()) {
        self.emailService = emailService
        loadData()
    }
    
    private func loadData() {
        tasks = coreDataManager.fetchTasks()
        focusSessions = coreDataManager.fetchFocusSessions()
    }
    
    func fetchTasks() async {
        isLoading = true
        do {
            let emailTasks = try await emailService.fetchEmails()
            tasks.append(contentsOf: emailTasks)
            emailTasks.forEach { coreDataManager.saveTask($0) }
        } catch {
            self.error = error
        }
        isLoading = false
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
        coreDataManager.saveTask(task)
    }
    
    func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            coreDataManager.saveTask(tasks[index])
        }
    }
    
    func scheduleFocusSession(_ session: FocusSession) {
        focusSessions.append(session)
        coreDataManager.saveFocusSession(session)
    }
    
    func completeFocusSession(_ session: FocusSession) {
        if let index = focusSessions.firstIndex(where: { $0.id == session.id }) {
            focusSessions[index].isCompleted = true
            coreDataManager.saveFocusSession(focusSessions[index])
        }
    }
    
    func getTasksForCategory(_ category: Category) -> [Task] {
        tasks.filter { $0.category == category }
    }
    
    func getUpcomingFocusSessions() -> [FocusSession] {
        focusSessions
            .filter { !$0.isCompleted }
            .sorted { ($0.scheduledTime ?? .distantFuture) < ($1.scheduledTime ?? .distantFuture) }
    }
} 