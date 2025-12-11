import SwiftUI

struct DateSelectionView: View {
    @State private var selectedDate = Date()
    @State private var navigateToHome = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            
            Spacer()
            
            // Logo / Icon (Smaller version for consistency or clear space)
            // Or just keep the specific icon but consistent spacing
             ZStack {
                Circle()
                    .fill(Color.sageGreen.opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "calendar.badge.clock")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.sageGreen)
            }
            .padding(.bottom, 10)
            
            // App Name (Optional, but adds continuity)
            Text("Mammafy")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.darkText)
            
            Spacer().frame(height: 30)
            
            DateSelectionTitle()
            
            Spacer().frame(height: 40)
            
            CalendarView(selectedDate: $selectedDate)
            
            Spacer()
            
            PrimaryButton(
                title: "Get Started",
                action: {
                    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                    PregnancyManager.shared.setStartDate(selectedDate)
                    navigateToHome = true
                },
                isDisabled: false
            )
            .padding(.bottom, 30)
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView()
            }
        }
        .background(Color.warmCream.edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
    }
}



struct DateSelectionTitle: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("When did your journey begin?")
            .font(.system(size: 24, weight: .bold, design: .rounded))
            .foregroundColor(.darkText)
            .multilineTextAlignment(.center)
            
            Text("Select the first day of your last period.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal)
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack {
            DatePicker(
                "Select Date",
                selection: $selectedDate,
                in: ...Date(), // Disable future dates
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .tint(.sageGreen) // Apply theme color
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .padding(.horizontal)
    }
}

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    let isDisabled: Bool
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(isDisabled ? .gray : .white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isDisabled ? Color.buttonDisabled : Color.sageGreen)
                .cornerRadius(16)
        }
        .disabled(isDisabled)
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        DateSelectionView()
    }
}
