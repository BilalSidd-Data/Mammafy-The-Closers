import SwiftUI

struct NameInputView: View {
    @State private var name: String = ""
    @State private var navigateToDateSelection = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Logo / Icon
            ZStack {
                Circle()
                    .fill(Color.sageGreen.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "heart.text.square.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.sageGreen)
            }
            .padding(.bottom, 10)
            
            // App Name
            Text("Mammafy")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(.darkText)
            
            // Question & Subtitle
            VStack(spacing: 8) {
                Text("What should we call you?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.darkText)
                
                Text("We'll use this to personalize your journey.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)

            Spacer().frame(height: 20)

            // Input
            TextField("Your Name", text: $name)
                .padding()
                .frame(height: 56)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.sageGreen.opacity(name.isEmpty ? 0 : 0.5), lineWidth: 1)
                )
                .padding(.horizontal)
                .submitLabel(.done)

            Spacer()

            // Button
            Button(action: {
                saveUserAndContinue()
            }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray.opacity(0.5) : Color.sageGreen)
                    .cornerRadius(28) // Fully rounded pill shape
            }
            .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .padding(.horizontal)
            .padding(.bottom, 30)
            .navigationDestination(isPresented: $navigateToDateSelection) {
                DateSelectionView()
            }
        }
        .background(Color.warmCream.edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
    }
    
    private func saveUserAndContinue() {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty else { return }
        
        UserDefaults.standard.set(cleanName, forKey: "currentUserName")
        
        // Refresh managers to use the new user's keys
        SupplementManager.shared.reloadForUser()
        PregnancyManager.shared.reloadForUser()
        VisitManager.shared.reloadForUser()
        
        navigateToDateSelection = true
    }
}

#Preview {
    NameInputView()
}
