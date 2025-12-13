import SwiftUI

struct MedicationDetailsForm: View {
    @Binding var name: String
    @Binding var dosage: String
    @Binding var instructions: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Medication Details")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.leading, 5)
            
            VStack(spacing: 0) {
                TextField("Name (e.g., Prenatal Vitamin)", text: $name)
                    .padding()
                
                Divider()
                    .padding(.leading)
                
                TextField("Dosage (e.g., 1 Tablet)", text: $dosage)
                    .padding()
                
                Divider()
                    .padding(.leading)
                
                TextField("Instructions (e.g., Take with food)", text: $instructions)
                    .padding()
            }
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
        .padding(.horizontal)
    }
}
