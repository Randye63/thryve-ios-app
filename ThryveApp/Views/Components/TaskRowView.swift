import SwiftUI
import CoreData

struct TaskRowView: View {
    @ObservedObject var task: Task
    let viewContext: NSManagedObjectContext
    
    var body: some View {
        HStack {
            Text(task.title ?? "Untitled")
                .foregroundColor(.white)
                .strikethrough(task.isCompleted)
            
            Spacer()
            
            Button(action: toggleTaskCompletion) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? Color(hex: "00A86B") : .white)
                    .imageScale(.large)
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .animation(.easeInOut, value: task.isCompleted)
    }
    
    private func toggleTaskCompletion() {
        let generator = UINotificationFeedbackGenerator()
        
        withAnimation {
            task.isCompleted.toggle()
            task.completedDate = task.isCompleted ? Date() : nil
            
            do {
                try viewContext.save()
                generator.notificationOccurred(task.isCompleted ? .success : .warning)
            } catch {
                print("Error saving completion status: \(error)")
                generator.notificationOccurred(.error)
                // Revert the change if save fails
                task.isCompleted.toggle()
                task.completedDate = task.isCompleted ? Date() : nil
            }
        }
    }
} 