@Environment(\.managedObjectContext) private var viewContext

@State private var showCompletedTasks = false
@State private var showErrorToast = false
@State private var errorMessage: String?

// Add animation namespace for smoother list transitions
@Namespace private var animation

// Add category color mapping
private let categoryColors: [String: Color] = [
    "habits": Color(hex: "00A86B"),
    "jobs": Color(hex: "00DDEB"),
    "personal": Color(hex: "FF6B6B")
]

var filteredTasks: [Task] {
    tasks.filter { task in
        if let category = filterCategory {
            return task.category == category
        }
        return true
    }.sorted { task1, task2 in
        if task1.isCompleted == task2.isCompleted {
            return task1.dueDate ?? Date() < task2.dueDate ?? Date()
        }
        return !task1.isCompleted && task2.isCompleted
    }
}

var body: some View {
    NavigationView {
        ZStack {
            Color(hex: "1C2526").edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                // Task Section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Tasks")
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.8))
                        if filterCategory != nil {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    filterCategory = nil
                                }
                            }) {
                                Text("Clear Filter")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "00A86B"))
                            }
                        }
                        Spacer()
                        Toggle("Show Completed", isOn: $showCompletedTasks)
                            .labelsHidden()
                            .tint(Color(hex: "00A86B"))
                    }
                    
                    if filteredTasks.isEmpty {
                        EmptyStateView()
                    } else {
                        ForEach(filteredTasks) { task in
                            TaskRowView(
                                task: task,
                                onComplete: { completed in
                                    updateTask(task, completed: completed)
                                }
                            )
                        }
                    }
                }
                .padding(.horizontal)
                
                // Progress Summary
                ProgressView(
                    completed: completedTasks,
                    total: filteredTasks.count
                )
            }
            
            // Error Handling
            if let error = errorMessage {
                ErrorToast(message: error)
            }
        }
        .navigationTitle("My Day")
    }
}

private func updateTask(_ task: Task, completed: Bool) {
    withAnimation {
        task.isCompleted = completed
        task.completedDate = completed ? Date() : nil
        
        do {
            try viewContext.save()
        } catch {
            errorMessage = "Failed to update task: \(error.localizedDescription)"
            // Revert on failure
            task.isCompleted = !completed
            task.completedDate = !completed ? Date() : nil
        }
    }
}

private var completedTasks: Int {
    filteredTasks.filter(\.isCompleted).count
}

// MARK: - Supporting Views

struct TaskRowView: View {
    let task: Task
    let onComplete: (Bool) -> Void
    
    var body: some View {
        HStack {
            Text(task.title ?? "Untitled")
                .foregroundColor(.white)
                .strikethrough(task.isCompleted)
            Spacer()
            Button(action: { onComplete(!task.isCompleted) }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? Color(hex: "00A86B") : .white)
                    .imageScale(.large)
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .animation(.easeInOut(duration: 0.3), value: task.isCompleted)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("No tasks for today")
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.8))
            Text("Add some tasks to get started!")
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.6))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

struct ProgressView: View {
    let completed: Int
    let total: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(completed)/\(total) tasks completed")
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(.horizontal)
    }
}

struct ErrorToast: View {
    let message: String
    
    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .padding()
            .background(Color.red.opacity(0.8))
            .cornerRadius(8)
            .transition(.move(edge: .top).combined(with: .opacity))
            .padding(.top)
    }
}

// Enhanced FilterView with category colors
struct FilterView: View {
    @Binding var selectedCategory: String?
    @Environment(\.dismiss) private var dismiss
    
    let categories = ["habits", "jobs", "personal"]
    let categoryColors: [String: Color] = [
        "habits": Color(hex: "00A86B"),
        "jobs": Color(hex: "00DDEB"),
        "personal": Color(hex: "FF6B6B")
    ]
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            withAnimation {
                                selectedCategory = category
                                dismiss()
                            }
                        }) {
                            HStack {
                                Circle()
                                    .fill(categoryColors[category] ?? .gray)
                                    .frame(width: 12, height: 12)
                                Text(category.capitalized)
                                Spacer()
                                if selectedCategory == category {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(categoryColors[category])
                                }
                            }
                        }
                    }
                }
                Button("Clear Filter") {
                    withAnimation {
                        selectedCategory = nil
                        dismiss()
                    }
                }
                .foregroundColor(.blue)
            }
            .navigationTitle("Filter Tasks")
            .toolbar {
                Button("Done") { dismiss() }
                    .foregroundColor(.blue)
            }
        }
    }
} 