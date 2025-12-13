import SwiftUI

struct QuestionsForDoctorView: View {
    @ObservedObject var manager = VisitManager.shared
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Questions for Doctor")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.darkText)
                
                Spacer()
                
                Button(action: {
                    isEditing.toggle()
                    if isEditing {
                        isFocused = true
                    } else {
                        isFocused = false
                    }
                }) {
                    Text(isEditing ? "Done" : "Edit")
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 2)
                        .foregroundColor(.sageGreen)
                }
            }
            .padding(.horizontal)
            
            ZStack(alignment: .topLeading) {
                if manager.questionsForDoctor.isEmpty && !isFocused {
                    Text("Type your questions here...")
                    .foregroundColor(.gray.opacity(0.6))
                    .padding(.top, 8)
                    .padding(.leading, 5)
                }
                
                TextEditor(text: $manager.questionsForDoctor)
                    .focused($isFocused)
                    .frame(height: 150)
                    .disabled(!isEditing)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.sageGreen.opacity(0.8), lineWidth: 1)
            )
            .padding(.horizontal)
        }
    }
}
