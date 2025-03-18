import SwiftUI

struct JobsView: View {
    @EnvironmentObject private var viewModel: AppViewModel
    @State private var showingAddJob = false
    @State private var selectedJob: Task?
    @State private var showingResumeSuggestions = false
    
    var body: some View {
        NavigationView {
            List {
                Section("Job Applications") {
                    ForEach(viewModel.getTasksForCategory(.jobs)) { job in
                        JobRow(job: job)
                            .onTapGesture {
                                selectedJob = job
                            }
                    }
                }
                
                Section("Resume Suggestions") {
                    Button(action: { showingResumeSuggestions = true }) {
                        HStack {
                            Text("Get Resume Suggestions")
                            Spacer()
                            Image(systemName: "doc.text.magnifyingglass")
                        }
                    }
                }
            }
            .navigationTitle("Jobs")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddJob = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddJob) {
                AddJobView()
            }
            .sheet(item: $selectedJob) { job in
                JobDetailView(job: job)
            }
            .sheet(isPresented: $showingResumeSuggestions) {
                ResumeSuggestionsView()
            }
        }
    }
}

struct JobRow: View {
    let job: Task
    @EnvironmentObject private var viewModel: AppViewModel
    
    var body: some View {
        HStack {
            Button(action: { viewModel.toggleTaskCompletion(job) }) {
                Image(systemName: job.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(job.isCompleted ? .green : .gray)
            }
            
            VStack(alignment: .leading) {
                Text(job.title)
                    .strikethrough(job.isCompleted)
                Text(job.description)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(job.dueDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            priorityIcon(for: job.priority)
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

struct AddJobView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: AppViewModel
    
    @State private var title = ""
    @State private var description = ""
    @State private var dueDate = Date()
    @State private var priority: Priority = .medium
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Company/Position", text: $title)
                TextField("Job Description", text: $description)
                DatePicker("Application Deadline", selection: $dueDate, displayedComponents: [.date])
                Picker("Priority", selection: $priority) {
                    ForEach([Priority.low, .medium, .high], id: \.self) { priority in
                        Text(priority.rawValue.capitalized)
                    }
                }
            }
            .navigationTitle("New Job Application")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let job = Task(
                            title: title,
                            description: description,
                            dueDate: dueDate,
                            priority: priority,
                            category: .jobs,
                            source: .manual
                        )
                        viewModel.addTask(job)
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

struct JobDetailView: View {
    let job: Task
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: AppViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section("Details") {
                    Text(job.title)
                    Text(job.description)
                    Text(job.dueDate, style: .date)
                    Text(job.priority.rawValue.capitalized)
                }
                
                Section {
                    Button(action: { viewModel.toggleTaskCompletion(job) }) {
                        HStack {
                            Text(job.isCompleted ? "Mark Incomplete" : "Mark Complete")
                            Spacer()
                            Image(systemName: job.isCompleted ? "xmark.circle" : "checkmark.circle")
                        }
                    }
                }
            }
            .navigationTitle("Job Details")
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

struct ResumeSuggestionsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentSkills = ""
    @State private var suggestions: [String] = []
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Your Current Skills") {
                    TextEditor(text: $currentSkills)
                        .frame(height: 100)
                }
                
                if isLoading {
                    Section {
                        ProgressView()
                    }
                } else if !suggestions.isEmpty {
                    Section("Suggested Skills to Add") {
                        ForEach(suggestions, id: \.self) { suggestion in
                            Text(suggestion)
                        }
                    }
                }
            }
            .navigationTitle("Resume Suggestions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Analyze") {
                        analyzeResume()
                    }
                    .disabled(currentSkills.isEmpty || isLoading)
                }
            }
        }
    }
    
    private func analyzeResume() {
        isLoading = true
        
        // Simulate AI analysis
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            suggestions = [
                "Add React.js experience",
                "Include cloud computing skills (AWS/Azure)",
                "Mention project management tools",
                "Highlight data analysis experience"
            ]
            isLoading = false
        }
    }
}

#Preview {
    JobsView()
        .environmentObject(AppViewModel())
} 