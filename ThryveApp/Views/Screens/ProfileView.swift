import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @State private var userEmail: String = Auth.auth().currentUser?.email ?? "Not logged in"
    @State private var showingLogoutAlert = false
    @State private var showingDeleteAccountAlert = false
    @State private var showingNotificationSettings = false
    @State private var showingEmailSettings = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "1C2526")
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 16) {
                        // User Info Section
                        VStack(spacing: 8) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                            
                            Text(userEmail)
                                .font(.system(size: 17))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        
                        // Settings Section
                        VStack(spacing: 12) {
                            SettingsButton(
                                title: "Notifications",
                                icon: "bell.fill",
                                action: { showingNotificationSettings = true }
                            )
                            
                            SettingsButton(
                                title: "Email Integration",
                                icon: "envelope.fill",
                                action: { showingEmailSettings = true }
                            )
                            
                            SettingsButton(
                                title: "Focus Preferences",
                                icon: "brain.head.profile",
                                action: { /* Navigate to focus preferences */ }
                            )
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        
                        // Data Section
                        VStack(spacing: 12) {
                            SettingsButton(
                                title: "Export Data",
                                icon: "square.and.arrow.up",
                                action: exportData
                            )
                            
                            SettingsButton(
                                title: "Clear All Data",
                                icon: "trash",
                                action: { /* Show clear data alert */ }
                            )
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        
                        // Account Section
                        VStack(spacing: 12) {
                            SettingsButton(
                                title: "Delete Account",
                                icon: "person.crop.circle.badge.minus",
                                action: { showingDeleteAccountAlert = true }
                            )
                            
                            Button(action: { showingLogoutAlert = true }) {
                                Text("Sign Out")
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(height: 48)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(hex: "00DDEB"),
                                                Color(hex: "00A86B")
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(16)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding()
                }
            }
            .navigationTitle("Profile")
            .alert("Log Out", isPresented: $showingLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Log Out", role: .destructive) {
                    do {
                        try Auth.auth().signOut()
                        // Navigate back to login screen
                    } catch {
                        print("Sign out failed: \(error)")
                    }
                }
            } message: {
                Text("Are you sure you want to log out?")
            }
            .alert("Delete Account", isPresented: $showingDeleteAccountAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    // Implement account deletion
                }
            } message: {
                Text("This action cannot be undone. All your data will be permanently deleted.")
            }
            .sheet(isPresented: $showingNotificationSettings) {
                NotificationSettingsView()
            }
            .sheet(isPresented: $showingEmailSettings) {
                EmailSettingsView()
            }
        }
    }
    
    private func exportData() {
        // Implement data export functionality
    }
}

struct SettingsButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.white)
                Text(title)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(8)
        }
    }
}

struct NotificationSettingsView: View {
    @AppStorage("taskReminders") private var taskReminders = true
    @AppStorage("habitReminders") private var habitReminders = true
    @AppStorage("focusReminders") private var focusReminders = true
    @AppStorage("reminderTime") private var reminderTime = 15
    
    var body: some View {
        NavigationView {
            List {
                Section("Reminders") {
                    Toggle("Task Reminders", isOn: $taskReminders)
                    Toggle("Habit Reminders", isOn: $habitReminders)
                    Toggle("Focus Session Reminders", isOn: $focusReminders)
                    
                    if taskReminders || habitReminders || focusReminders {
                        Stepper("Remind \(reminderTime) minutes before", value: $reminderTime, in: 5...60, step: 5)
                    }
                }
            }
            .navigationTitle("Notification Settings")
        }
    }
}

struct EmailSettingsView: View {
    @AppStorage("emailIntegration") private var emailIntegration = false
    @AppStorage("autoCreateTasks") private var autoCreateTasks = true
    @AppStorage("emailCheckInterval") private var emailCheckInterval = 30
    
    var body: some View {
        NavigationView {
            List {
                Section("Email Integration") {
                    Toggle("Enable Email Integration", isOn: $emailIntegration)
                    
                    if emailIntegration {
                        Toggle("Auto-create Tasks from Emails", isOn: $autoCreateTasks)
                        Stepper("Check emails every \(emailCheckInterval) minutes", value: $emailCheckInterval, in: 5...120, step: 5)
                    }
                }
            }
            .navigationTitle("Email Settings")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
} 