import SwiftUI

struct HomeHeader: View {
    @State private var showResetConfirmation = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true
    @AppStorage("currentUserName") private var currentUserName = ""
    
    var body: some View {
        ZStack {
            // Centered Title
            Text("Daily Dose")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.darkText)
                .frame(maxWidth: .infinity)
            
            // Buttons
            HStack {
                Button(action: {
                    showResetConfirmation = true
                }) {
                    Image(systemName: "arrow.triangle.2.circlepath.circle")
                        .font(.title2)
                        .foregroundColor(.sageGreen)
                }
                .confirmationDialog("Start New Journey?", isPresented: $showResetConfirmation, titleVisibility: .visible) {
                    Button("Reset All Data", role: .destructive) {
                        resetAllData()
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("This will permanently delete your current data, including supplements, history, and appointments, to start a new pregnancy journey. This cannot be undone.")
                }
                
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
    private func resetAllData() {
        // Clear User Defaults Keys
        let name = currentUserName
        if !name.isEmpty {
            UserDefaults.standard.removeObject(forKey: "\(name)_savedSupplements")
            UserDefaults.standard.removeObject(forKey: "\(name)_supplementHistory")
            UserDefaults.standard.removeObject(forKey: "\(name)_pregnancyStartDate")
            UserDefaults.standard.removeObject(forKey: "\(name)_savedAppointment")
            UserDefaults.standard.removeObject(forKey: "\(name)_savedChecklist")
            UserDefaults.standard.removeObject(forKey: "\(name)_savedQuestions")
        }
        
        // Also clear active notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Reset Local Managers
        SupplementManager.shared.supplements = []
        SupplementManager.shared.history = []
        VisitManager.shared.appointment = nil
        VisitManager.shared.checklist = []
        
        // Reset User Identity
        currentUserName = ""
        hasCompletedOnboarding = false
    }
}
