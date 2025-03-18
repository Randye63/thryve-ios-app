import CoreData

import CoreData

class Task: NSManagedObject {
    @NSManaged public var completedDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var createdAt: Date?

    var isCompleted: Bool {
        return completedDate != nil
    }

    convenience init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)!
        self.init(entity: entity, insertInto: context)
        self.id = UUID()
        self.createdAt = Date()
    }
}
        self.createdAt = Date()
    }
} 