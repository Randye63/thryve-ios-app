import SwiftUI
import CoreData

struct JobsView: View {
    @FetchRequest(
        entity: JobApplication.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \JobApplication.deadline, ascending: true)]
    ) var jobApplications: FetchedResults<JobApplication>
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showSuggestion = false
    @State private var errorMessage: String?
    @State private var newJobTitle = ""
    @State private var newJobCompany = ""
    @State private var filterStatus: String? = nil
    
    var body: some View {
        ThryveLayout {
            // Your existing JobsView content
            ThryveCard {
                // Job content
            }
            
            ThryveInput(placeholder: "Job Title", text: $newJobTitle)
            ThryveInput(placeholder: "Company", text: $newJobCompany)
            
            ThryveButton("Add Job", style: .gradient) {
                addNewJob()
            }
        }
    }
    
    private var filterSection: some View {
        HStack {
            Button(action: { filterStatus = filterStatus == "Applied" ? nil : "Applied" }) {
                HStack {
                    Image(systemName: filterStatus == "Applied" ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                    Text(filterStatus == "Applied" ? "Show All" : "Show Applied")
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
            }
            
            Spacer()
            
            Text("\(filteredJobs.count) Applications")
                .foregroundColor(.white.opacity(0.6))
                .font(.subheadline)
        }
        .padding(.horizontal)
    }
    
    private var jobListSection: some View {
        VStack(spacing: 12) {
            if filteredJobs.isEmpty {
                EmptyStateView()
            } else {
                ForEach(filteredJobs) { job in
                    JobCard(job: job, viewContext: viewContext)
                }
            }
        }
    }
    
    private var addJobSection: some View {
        VStack(spacing: 12) {
            TextField("Job Title", text: $newJobTitle)
                .textFieldStyle(ThryveTextFieldStyle())
            
            TextField("Company", text: $newJobCompany)
                .textFieldStyle(ThryveTextFieldStyle())
            
            Button(action: addNewJob) {
                Text("Add Job")
                    .buttonStyle(ThryveGradientButtonStyle())
            }
        }
        .padding(.horizontal)
    }
    
    private var actionButtons: some View {
        Button(action: { showSuggestion = true }) {
            Text("Get Resume Suggestions")
                .buttonStyle(ThryveGradientButtonStyle())
        }
        .padding(.horizontal)
    }
    
    private func addNewJob() {
        guard !newJobTitle.isEmpty, !newJobCompany.isEmpty else {
            errorMessage = "Please fill in all fields"
            return
        }
        
        let newJob = JobApplication(context: viewContext)
        newJob.id = UUID()
        newJob.title = newJobTitle
        newJob.company = newJobCompany
        newJob.status = "Applied"
        newJob.deadline = Date().addingTimeInterval(7 * 24 * 60 * 60)
        
        do {
            try viewContext.save()
            newJobTitle = ""
            newJobCompany = ""
            errorMessage = nil
        } catch {
            errorMessage = "Failed to add job: \(error.localizedDescription)"
        }
    }
    
    var filteredJobs: [JobApplication] {
        guard let status = filterStatus else { return Array(jobApplications) }
        return jobApplications.filter { $0.status == status }
    }
}

// MARK: - Supporting Views
struct JobCard: View {
    @ObservedObject var job: JobApplication
    let viewContext: NSManagedObjectContext
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(job.title ?? "Untitled")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Company: \(job.company ?? "N/A")")
                .foregroundColor(.white.opacity(0.6))
            
            Text("Deadline: \(job.deadline ?? Date(), formatter: dateFormatter)")
                .foregroundColor(.white.opacity(0.6))
            
            Text("Status: \(job.status ?? "Applied")")
                .foregroundColor(statusColor)
            
            HStack(spacing: 12) {
                StatusButton(
                    title: "Interview",
                    color: Color(hex: "00A86B"),
                    isSelected: job.status == "Interview Scheduled"
                ) {
                    updateStatus("Interview Scheduled")
                }
                
                StatusButton(
                    title: "Rejected",
                    color: .red,
                    isSelected: job.status == "Rejected"
                ) {
                    updateStatus("Rejected")
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var statusColor: Color {
        switch job.status {
        case "Interview Scheduled": return Color(hex: "00A86B")
        case "Rejected": return .red
        default: return .white.opacity(0.6)
        }
    }
    
    private func updateStatus(_ status: String) {
        job.status = status
        try? viewContext.save()
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

struct StatusButton: View {
    let title: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .padding(8)
                .background(color.opacity(isSelected ? 0.3 : 0.1))
                .cornerRadius(8)
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "briefcase")
                .font(.system(size: 40))
                .foregroundColor(.white.opacity(0.6))
            
            Text("No job applications yet")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Add your first job application to get started!")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal)
    }
} 