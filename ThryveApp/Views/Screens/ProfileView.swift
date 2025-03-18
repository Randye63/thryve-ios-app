import SwiftUI
import FirebaseCore
import FirebaseAuth

struct ProfileView: View {
    @StateObject private var authManager = AuthManager()
    @State private var userEmail: String = Auth.auth().currentUser?.email ?? "Not logged in"
    @State private var showingLogoutAlert = false
    @State private var showingDeleteAccountAlert = false
    @State private var showingNotificationSettings = false
    @State private var showingEmailSettings = false
    
    var body: some View {
        VStack {
            // Profile header
            Text("Profile")
                .font(.largeTitle)
                .foregroundColor(.white)
            
            // User info
            Text(userEmail)
                .foregroundColor(.white)
                .padding()
            
            // Settings buttons
            VStack(spacing: 16) {
                Button(action: { showingNotificationSettings = true }) {
                    Text("Notification Settings")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                }
                
                Button(action: { showingEmailSettings = true }) {
                    Text("Email Settings")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                }
                
                Button(action: { showingLogoutAlert = true }) {
                    Text("Logout")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.3))
                        .cornerRadius(12)
                }
                
                Button(action: { showingDeleteAccountAlert = true }) {
                    Text("Delete Account")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.3))
                        .cornerRadius(12)
                }
            }
            .padding()
            
            Spacer()
        }
        .background(Color(hex: "1C2526"))
        .alert("Logout", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Logout", role: .destructive) {
                logout()
            }
        }
        .alert("Delete Account", isPresented: $showingDeleteAccountAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteAccount()
            }
        }
    }
    
    private func logout() {
        do {
            try Auth.auth().signOut()
            // Handle post-logout navigation
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    private func deleteAccount() {
        Auth.auth().currentUser?.delete { error in
            if let error = error {
                print("Error deleting account: \(error.localizedDescription)")
            } else {
                // Handle post-deletion navigation
            }
        }
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
