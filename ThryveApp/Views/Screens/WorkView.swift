import SwiftUI

struct WorkView: View {
    @EnvironmentObject private var viewModel: AppViewModel
    @State private var showingAddTask = false
    @State private var showingFocusSession = false
    @State private var selectedTask: Task?
    
    var body: some View {
        NavigationView {
            List {
                Section("Upcoming Focus Sessions") {
                    ForEach(viewModel.getUpcomingFocusSessions()) { session in
                        FocusSessionRow(session: session)
                    }
                }
                
                Section("Tasks") {
                    ForEach(viewModel.getTasksForCategory(.work)) { task in
                        TaskRow(task: task)
                            .onTapGesture {
                                selectedTask = task
                            }
                    }
                }
            }
            .navigationTitle("Work")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTask = true }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingFocusSession = true }) {
                        Image(systemName: "timer")
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView(category: .work)
            }
            .sheet(isPresented: $showingFocusSession) {
                AddFocusSessionView()
            }
            .sheet(item: $selectedTask) { task in
                TaskDetailView(task: task)
            }
        }
    }
}

struct TaskRow: View {
    let task: Task
    @EnvironmentObject private var viewModel: AppViewModel
    
    var body: some View {
        HStack {
            Button(action: { viewModel.toggleTaskCompletion(task) }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            
            VStack(alignment: .leading) {
                Text(task.title)
                    .strikethrough(task.isCompleted)
                Text(task.dueDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            priorityIcon(for: task.priority)
        }
    }
    
    private func priorityIcon(for priority: Priority) -> some View {
        let (color, icon) = {
            switch priority {
            case .high: return (Color.red, "exclamationmark.circle.fill")
            case .medium: return (Color.orange, "exclamationmark.circle")
            case .low: return (Color.green, "checkmark.circle")
            }
        }()
        
        return Image(systemName: icon)
            .foregroundColor(color)
    }
}

struct FocusSessionRow: View {
    let session: FocusSession
    @EnvironmentObject private var viewModel: AppViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(session.title)
                if let scheduledTime = session.scheduledTime {
                    Text(scheduledTime, style: .time)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Button(action: { viewModel.completeFocusSession(session) }) {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.green)
            }
        }
    }
}

struct AddTaskView: View {
    let category: Category
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: AppViewModel
    
    @State private var title = ""
    @State private var description = ""
    @State private var dueDate = Date()
    @State private var priority: Priority = .medium
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                Picker("Priority", selection: $priority) {
                    ForEach([Priority.low, .medium, .high], id: \.self) { priority in
                        Text(priority.rawValue.capitalized)
                    }
                }
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let task = Task(
                            title: title,
                            description: description,
                            dueDate: dueDate,
                            priority: priority,
                            category: category,
                            source: .manual
                        )
                        viewModel.addTask(task)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AddFocusSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: AppViewModel
    
    @State private var title = ""
    @State private var duration: TimeInterval = 60
    @State private var type: SessionType = .mindfulBreak
    @State private var scheduledTime = Date()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                Picker("Type", selection: $type) {
                    ForEach([SessionType.mindfulBreak, .focusSession, .quickReset], id: \.self) { type in
                        Text(type.rawValue)
                    }
                }
                DatePicker("Scheduled Time", selection: $scheduledTime)
                Stepper("Duration: \(Int(duration)) seconds", value: $duration, in: 30...3600, step: 30)
            }
            .navigationTitle("New Focus Session")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let session = FocusSession(
                            title: title,
                            duration: duration,
                            type: type,
                            scheduledTime: scheduledTime
                        )
                        viewModel.scheduleFocusSession(session)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct TaskDetailView: View {
    let task: Task
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: AppViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section("Details") {
                    Text(task.title)
                    Text(task.description)
                    Text(task.dueDate, style: .date)
                    Text(task.priority.rawValue.capitalized)
                }
                
                Section {
                    Button(action: { viewModel.toggleTaskCompletion(task) }) {
                        HStack {
                            Text(task.isCompleted ? "Mark Incomplete" : "Mark Complete")
                            Spacer()
                            Image(systemName: task.isCompleted ? "xmark.circle" : "checkmark.circle")
                        }
                    }
                }
            }
            .navigationTitle("Task Details")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    WorkView()
        .environmentObject(AppViewModel())
} 