import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create sample data
        for _ in 0..<10 {
            let newTask = Task(from: viewContext as! Decoder)
            newTask.id = UUID()
            newTask.title = "Sample Habit"
            newTask.dueDate = Date()
            newTask.category = "habits"
            newTask.isCompleted = Bool.random()
            
            let newFocusSession = FocusSession(context: viewContext)
            newFocusSession.id = UUID()
            newFocusSession.title = "Sample Focus Session"
            newFocusSession.duration = 25
            newFocusSession.type = "focusSession"
            newFocusSession.scheduledTime = Date()
            newFocusSession.isCompleted = Bool.random()
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Thryve")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
} 
