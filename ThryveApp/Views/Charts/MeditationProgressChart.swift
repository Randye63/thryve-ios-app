import SwiftUI
import Charts

struct MeditationProgressChart: View {
    let sessions: [MeditationSession]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Meditation Progress")
                .font(.headline)
                .foregroundColor(.white)
            
            Chart {
                ForEach(sessions) { session in
                    BarMark(
                        x: .value("Date", session.date, unit: .day),
                        y: .value("Minutes", session.minutes)
                    )
                    .foregroundStyle(
                        session.completed ?
                        ThryveColors.primaryGradient :
                        Color.white.opacity(0.3)
                    )
                }
            }
            .frame(height: 200)
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        Text("\(value.as(Int.self) ?? 0)m")
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let date = value.as(Date.self) {
                            Text(date, format: .dateTime.weekday(.short))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }
            }
            
            // Summary
            HStack {
                StatCard(
                    title: "Total Minutes",
                    value: "\(totalMinutes)m"
                )
                
                StatCard(
                    title: "Completion Rate",
                    value: "\(Int(completionRate * 100))%"
                )
                
                StatCard(
                    title: "Avg. Duration",
                    value: "\(averageMinutes)m"
                )
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
    
    private var totalMinutes: Int {
        sessions.reduce(0) { $0 + $1.minutes }
    }
    
    private var completionRate: Double {
        Double(sessions.filter(\.completed).count) / Double(sessions.count)
    }
    
    private var averageMinutes: Int {
        sessions.isEmpty ? 0 : totalMinutes / sessions.count
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
            
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
    }
}

// Preview
struct MeditationProgressChart_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(hex: "1C2526").ignoresSafeArea()
            MeditationProgressChart(
                sessions: TestDataGenerator.shared.generateRealisticWeeklyMeditations()
            )
            .padding()
        }
    }
} 