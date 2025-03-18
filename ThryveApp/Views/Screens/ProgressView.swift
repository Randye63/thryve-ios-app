import SwiftUI
import Charts
import SwiftUI
import SwiftUI
import Charts

struct ProgressView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var selectedTimeRange: TimeRange = .week
    
    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }
        case month = "Month"
        case year = "Year"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Time Range Picker
                    Picker("Time Range", selection: $selectedTimeRange) {
                        ForEach(TimeRange.allCases, id: \.self) { range in
                            Text(range.rawValue).tag(range)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // Habit Completion Chart
                    VStack(alignment: .leading) {
                        Text("Habit Completion")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Chart {
                            ForEach(habitCompletionData) { data in
                                LineMark(
                                    x: .value("Date", data.date),
                                    y: .value("Completion Rate", data.completionRate)
                                )
                                .foregroundStyle(.blue)
                            }
                        }
                        .frame(height: 200)
                        .padding()
                    }
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    
                    // Focus Sessions Chart
                    VStack(alignment: .leading) {
                        Text("Focus Sessions")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Chart {
                            ForEach(focusSessionData) { data in
                                BarMark(
                                    x: .value("Date", data.date),
                                    y: .value("Duration", data.duration)
                                )
                                .foregroundStyle(.green)
                            }
                        }
                        .frame(height: 200)
                        .padding()
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    
                    // Task Completion Stats
                    VStack(alignment: .leading) {
                        Text("Task Completion")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        HStack {
                            StatCard(
                                title: "Completed",
                                value: "\(completedTasks)",
                                color: .green
                            )
                            
                            StatCard(
                                title: "Pending",
                                value: "\(pendingTasks)",
                                color: .orange
                            )
                            
                            StatCard(
                                title: "Overdue",
                                value: "\(overdueTasks)",
                                color: .red
                            )
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                }
                .padding()
            }
            .navigationTitle("Progress")
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
    
    // Sample data for charts
    private var habitCompletionData: [HabitData] {
        // Generate sample data based on selected time range
        let calendar = Calendar.current
        let now = Date()
        var data: [HabitData] = []
        
        for dayOffset in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: now)!
            data.append(HabitData(
                date: date,
                completionRate: Double.random(in: 0.5...1.0)
            ))
        }
        
        return data.reversed()
    }
    
    private var focusSessionData: [FocusData] {
        // Generate sample data based on selected time range
        let calendar = Calendar.current
        let now = Date()
        var data: [FocusData] = []
        
        for dayOffset in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: now)!
            data.append(FocusData(
                date: date,
                duration: Double.random(in: 25...120)
            ))
        }
        
        return data.reversed()
    }
    
    private var completedTasks: Int {
        appViewModel.tasks.filter { $0.isCompleted }.count
    }
    
    private var pendingTasks: Int {
        appViewModel.tasks.filter { !$0.isCompleted && $0.dueDate > Date() }.count
    }
    
    private var overdueTasks: Int {
        appViewModel.tasks.filter { !$0.isCompleted && $0.dueDate < Date() }.count
    }
}

struct HabitData: Identifiable {
    let id = UUID()
    let date: Date
    let completionRate: Double
}

struct FocusData: Identifiable {
    let id = UUID()
    let date: Date
    let duration: Double
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
} 