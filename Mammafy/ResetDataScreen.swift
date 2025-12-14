import SwiftUI

struct ResetDataScreen: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true
    @AppStorage("currentUserName") private var currentUserName = ""
    
    var body: some View {
        VStack(spacing: 30) {
            // Icon
            Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.sageGreen)
                .padding(.top, 60)
            
            // Text Content
            VStack(spacing: 16) {
                Text("Start New Journey?")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.darkText)
                
                Text("This will permanently delete your current data, including supplements, history, and appointments, to start a new pregnancy journey.\n\nThis cannot be undone.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .lineSpacing(6)
            }
            
            Spacer()
            
            // Buttons
            VStack(spacing: 16) {
                Button(action: {
                    resetAllData()
                }) {
                    Text("Reset All Data")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.85)) // Destructive Red
                        .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                
                Button("Cancel") {
                    dismiss()
                }
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
            }
        }
        .background(Color.warmCream.edgesIgnoringSafeArea(.all))
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
        
        // Dismiss this view (though the app will likely switch root view immediately due to hasCompletedOnboarding changing)
        dismiss()
    }
}

#Preview {
    ResetDataScreen()
}
