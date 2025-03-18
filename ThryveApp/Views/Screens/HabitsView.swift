import SwiftUI

struct HabitsView: View {
    @EnvironmentObject private var viewModel: AppViewModel
    @State private var showingAddHabit = false
    @State private var selectedHabit: Task?
    
    var body: some View {
        NavigationView {
            List {
                Section("Daily Habits") {
                    ForEach(viewModel.getTasksForCategory(.habits)) { habit in
                        HabitRow(habit: habit)
                            .onTapGesture {
                                selectedHabit = habit
                            }
                    }
                }
                
                Section("Focus Sessions") {
                    ForEach(viewModel.getUpcomingFocusSessions()) { session in
                        if session.type == .mindfulBreak {
                            FocusSessionRow(session: session)
                        }
                    }
                }
            }
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddHabit = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView()
            }
            .sheet(item: $selectedHabit) { habit in
                HabitDetailView(habit: habit)
            }
        }
    }
}

struct HabitRow: View {
    let habit: Task
    @EnvironmentObject private var viewModel: AppViewModel
    
    var body: some View {
        HStack {
            Button(action: { viewModel.toggleTaskCompletion(habit) }) {
                Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(habit.isCompleted ? .green : .gray)
            }
            
            VStack(alignment: .leading) {
                Text(habit.title)
                    .strikethrough(habit.isCompleted)
                Text(habit.description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if let dueDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) {
                Text(dueDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: AppViewModel
    
    @State private var title = ""
    @State private var description = ""
    @State private var reminderTime = Date()
    @State private var enableReminder = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Habit Details") {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                }
                
                Section("Reminder") {
                    Toggle("Enable Daily Reminder", isOn: $enableReminder)
                    if enableReminder {
                        DatePicker("Reminder Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                    }
                }
            }
            .navigationTitle("New Habit")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let habit = Task(
                            title: title,
                            description: description,
                            dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(),
                            priority: .medium,
                            category: .habits,
                            source: .manual
                        )
                        viewModel.addTask(habit)
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

struct HabitDetailView: View {
    let habit: Task
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: AppViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section("Details") {
                    Text(habit.title)
                    Text(habit.description)
                }
                
                Section {
                    Button(action: { viewModel.toggleTaskCompletion(habit) }) {
                        HStack {
                            Text(habit.isCompleted ? "Mark Incomplete" : "Mark Complete")
                            Spacer()
                            Image(systemName: habit.isCompleted ? "xmark.circle" : "checkmark.circle")
                        }
                    }
                }
            }
            .navigationTitle("Habit Details")
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
    HabitsView()
        .environmentObject(AppViewModel())
} 