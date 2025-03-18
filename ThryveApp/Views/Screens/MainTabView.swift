import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            WorkView()
                .tabItem {
                    Label("Work", systemImage: "briefcase.fill")
                }
                .tag(0)
            
            HabitsView()
                .tabItem {
                    Label("Habits", systemImage: "list.bullet.clipboard.fill")
                }
                .tag(1)
            
            JobsView()
                .tabItem {
                    Label("Jobs", systemImage: "doc.text.fill")
                }
                .tag(2)
            
            ProgressView()
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.fill")
                }
                .tag(3)
            
            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "message.fill")
                }
                .tag(4)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(5)
        }
    }
}

#Preview {
    MainTabView()
} 