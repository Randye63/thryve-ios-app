import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ThryveApp")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load Core Data store: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    // MARK: - Task Operations
    
    func saveTask(_ task: Task) {
        let entity = TaskEntity(context: context)
        entity.id = task.id
        entity.title = task.title
        entity.desc = task.description
        entity.dueDate = task.dueDate
        entity.priority = task.priority.rawValue
        entity.category = task.category.rawValue
        entity.isCompleted = task.isCompleted
        entity.source = task.source.rawValue
        entity.createdAt = Date()
        
        saveContext()
    }
    
    func fetchTasks() -> [Task] {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TaskEntity.dueDate, ascending: true)]
        
        do {
            let entities = try context.fetch(request)
            return entities.map { entity in
                Task(
                    id: entity.id ?? UUID(),
                    title: entity.title ?? "",
                    description: entity.desc ?? "",
                    dueDate: entity.dueDate ?? Date(),
                    priority: Priority(rawValue: entity.priority ?? "") ?? .medium,
                    category: Category(rawValue: entity.category ?? "") ?? .work,
                    isCompleted: entity.isCompleted,
                    source: TaskSource(rawValue: entity.source ?? "") ?? .manual
                )
            }
        } catch {
            print("Error fetching tasks: \(error)")
            return []
        }
    }
    
    // MARK: - Focus Session Operations
    
    func saveFocusSession(_ session: FocusSession) {
        let entity = FocusSessionEntity(context: context)
        entity.id = session.id
        entity.title = session.title
        entity.duration = session.duration
        entity.type = session.type.rawValue
        entity.scheduledTime = session.scheduledTime
        entity.isCompleted = session.isCompleted
        entity.notes = session.notes
        entity.createdAt = Date()
        
        saveContext()
    }
    
    func fetchFocusSessions() -> [FocusSession] {
        let request: NSFetchRequest<FocusSessionEntity> = FocusSessionEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FocusSessionEntity.scheduledTime, ascending: true)]
        
        do {
            let entities = try context.fetch(request)
            return entities.map { entity in
                FocusSession(
                    id: entity.id ?? UUID(),
                    title: entity.title ?? "",
                    duration: entity.duration,
                    type: SessionType(rawValue: entity.type ?? "") ?? .focusSession,
                    scheduledTime: entity.scheduledTime,
                    isCompleted: entity.isCompleted,
                    notes: entity.notes
                )
            }
        } catch {
            print("Error fetching focus sessions: \(error)")
            return []
        }
    }
} 