import SwiftUI

struct SettingsScreen: View {
    @Environment(\.dismiss) var dismiss
    @State private var showResetConfirmation = false
    
    // We can pull the user name if needed
    @AppStorage("currentUserName") private var currentUserName = ""

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Profile")) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.title2)
                            .foregroundColor(.sageGreen)
                        Text(currentUserName.isEmpty ? "Mama" : currentUserName)
                            .font(.headline)
                            .foregroundColor(.darkText)
                    }
                }
                
                Section(header: Text("Data Management")) {
                    Button(action: {
                        showResetConfirmation = true
                    }) {
                        HStack {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .foregroundColor(.red)
                            Text("Start New Journey")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.sageGreen)
                }
            }
            .sheet(isPresented: $showResetConfirmation) {
                ResetDataScreen()
            }
        }
    }
}

#Preview {
    SettingsScreen()
}
