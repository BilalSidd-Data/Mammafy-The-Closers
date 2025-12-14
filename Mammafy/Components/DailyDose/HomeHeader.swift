import SwiftUI

struct HomeHeader: View {
    @State private var showSettings = false
    
    var body: some View {
        ZStack {
            // Centered Title
            Text("Daily Dose")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.darkText)
                .frame(maxWidth: .infinity)
            
            // Buttons
            HStack {
                Spacer()
                
                Button(action: {
                    showSettings = true
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(.sageGreen)
                }
                .sheet(isPresented: $showSettings) {
                    SettingsScreen()
                }
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
}
